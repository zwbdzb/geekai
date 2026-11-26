<template>
  <!-- 公开协议页：/agreement、/privacy 共用，内容来自后台配置（configs 表），实时读取 -->
  <div class="min-h-screen bg-canvas">
    <section class="pt-28 pb-16">
      <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="font-serif text-3xl sm:text-[2.5rem] font-normal tracking-[-0.03em] text-ink mb-8">
          {{ t(titleKey) }}
        </h1>

        <div v-if="loading" class="py-16 text-center text-sm text-muted">{{ t('policy.loading') }}</div>
        <div v-else-if="error" class="py-16 text-center text-sm text-muted">
          {{ t('policy.load_failed') }}
          <button class="policy-retry" type="button" @click="load">{{ t('policy.retry') }}</button>
        </div>
        <p v-else-if="!html" class="py-16 text-center text-sm text-muted">{{ t('policy.empty') }}</p>
        <article v-else class="policy-content" v-html="html"></article>
      </div>
    </section>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { useRoute } from 'vue-router'
import { httpGet } from '@/utils/http'
import { marked } from 'marked'

const route = useRoute()
const { t } = useI18n()

const docKey = computed(() => (route.path === '/privacy' ? 'privacy' : 'agreement'))
const titleKey = computed(() => (docKey.value === 'privacy' ? 'policy.privacy_title' : 'policy.agreement_title'))

const loading = ref(true)
const error = ref(false)
const html = ref('')

const load = () => {
  loading.value = true
  error.value = false
  httpGet(`/api/config/get?key=${docKey.value}`)
    .then((res) => {
      html.value = marked.parse(res.data?.content || '')
    })
    .catch(() => {
      error.value = true
    })
    .finally(() => {
      loading.value = false
    })
}

// 同一组件在 /agreement 与 /privacy 之间复用，路径变化时重新加载
watch(docKey, load, { immediate: true })
</script>

<style scoped>
.policy-retry {
  margin-left: 8px;
  padding: 2px 10px;
  border: 1px solid var(--tw-color-hairline, #e1dcd6);
  border-radius: 6px;
  font-size: 13px;
  color: #1a1815;
  background: transparent;
  cursor: pointer;
}

.policy-retry:hover {
  border-color: #3b5bdb;
  color: #3b5bdb;
}

/* Markdown 正文排版：适配后台 md-editor 产出的常见元素 */
.policy-content {
  font-size: 15px;
  line-height: 1.85;
  color: #474039;
  word-break: break-word;
}

.policy-content :deep(h1),
.policy-content :deep(h2),
.policy-content :deep(h3),
.policy-content :deep(h4) {
  margin: 1.6em 0 0.6em;
  font-weight: 600;
  color: #1a1815;
  line-height: 1.4;
}

.policy-content :deep(h1) {
  font-size: 1.5em;
}

.policy-content :deep(h2) {
  font-size: 1.25em;
}

.policy-content :deep(h3),
.policy-content :deep(h4) {
  font-size: 1.1em;
}

.policy-content :deep(p) {
  margin: 0.8em 0;
}

.policy-content :deep(ul),
.policy-content :deep(ol) {
  margin: 0.8em 0;
  padding-left: 1.6em;
}

.policy-content :deep(ul) {
  list-style: disc;
}

.policy-content :deep(ol) {
  list-style: decimal;
}

.policy-content :deep(li) {
  margin: 0.3em 0;
}

.policy-content :deep(a) {
  color: #3b5bdb;
  text-decoration: underline;
  text-underline-offset: 2px;
}

.policy-content :deep(blockquote) {
  margin: 1em 0;
  padding: 0.5em 1em;
  border-left: 3px solid #e1dcd6;
  color: #6f6961;
  background: #f7f6f3;
  border-radius: 0 8px 8px 0;
}

.policy-content :deep(code) {
  padding: 0.15em 0.4em;
  border-radius: 4px;
  background: #f0ede8;
  font-size: 0.9em;
}

.policy-content :deep(pre) {
  margin: 1em 0;
  padding: 1em;
  border-radius: 8px;
  background: #f0ede8;
  overflow-x: auto;
}

.policy-content :deep(pre code) {
  padding: 0;
  background: transparent;
}

.policy-content :deep(table) {
  width: 100%;
  margin: 1em 0;
  border-collapse: collapse;
  font-size: 0.95em;
}

.policy-content :deep(th),
.policy-content :deep(td) {
  padding: 0.5em 0.75em;
  border: 1px solid #e1dcd6;
  text-align: left;
}

.policy-content :deep(th) {
  background: #f0ede8;
  font-weight: 600;
  color: #1a1815;
}

.policy-content :deep(img) {
  max-width: 100%;
  border-radius: 8px;
}

.policy-content :deep(hr) {
  margin: 1.5em 0;
  border: none;
  border-top: 1px solid #e1dcd6;
}
</style>
