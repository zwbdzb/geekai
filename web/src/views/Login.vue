<template>
  <!-- Tokengine OAuth handoff 覆盖层：在 tokengine=success/error query 存在期间
       同步渲染，阻止登录表单闪现，直到后端 complete 或失败回退 -->
  <div v-if="isHandoff" class="handoff-overlay">
    <img class="handoff-logo" :src="'/assets/logo.png'" alt="ThinkBuddy" />
    <div class="handoff-spinner" aria-hidden="true" />
    <p class="handoff-text">正在登录…</p>
  </div>

  <div v-else class="login-page">
    <header class="login-header">
      <a href="/" class="login-brand" aria-label="ThinkBuddy 首页">
        <img :src="'/assets/logo.png'" width="32" height="32" alt="" />
        <span>ThinkBuddy</span>
      </a>
    </header>

    <main class="login-main">
      <section class="login-card" aria-labelledby="login-title">
        <a href="/" class="login-back">
          <el-icon><ArrowLeft /></el-icon>
          <span>返回首页</span>
        </a>
        <div class="login-intro">
          <h1 id="login-title" class="login-title">{{ title }}</h1>
          <p v-if="isRegister">{{ subtitle }}</p>
        </div>

        <div class="register-content">
          <login-dialog
            :show="true"
            :active="active"
            :inviteCode="inviteCode"
            @success="handleRegisterSuccess"
            @changeActive="handleChangeActive"
          />
        </div>
      </section>
    </main>

    <footer class="login-footer">
      © {{ currentYear }} ThinkBuddy. Powered by ThinkBuddy (hanyoai).
    </footer>
  </div>
</template>

<script setup>
import LoginDialog from '@/components/LoginDialog.vue'
import { ArrowLeft } from '@element-plus/icons-vue'
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { setUserToken } from '@/store/session'
import { useSharedStore } from '@/store/sharedata'
import { httpPost } from '@/utils/http'
import { ElMessage } from 'element-plus'
import { safeRedirect } from '@/utils/redirect'
import { loadAuthUser } from '@/composables/useAuth'

const route = useRoute()
const router = useRouter()
const store = useSharedStore()
const currentYear = new Date().getFullYear()
const inviteCode = route.query.invite_code || route.query.invite || ''

/* Tokengine OAuth 回跳期间的同步覆盖层判定：在 setup 阶段同步完成，
   首次 render 就阻止登录表单出现，避免在 onMounted 异步执行前闪出登录界面。 */
const isHandoff = computed(() => route.query.tokengine === 'success' || route.query.tokengine === 'error')
const isRegister = ref(router.currentRoute.value.path === '/register')
const active = isRegister.value ? 'register' : 'login'
const title = computed(() => (isRegister.value ? '用户注册' : '用户登录'))
const subtitle = computed(() =>
  isRegister.value ? '创建您的账户以开始使用服务' : '登录您的账户以继续使用服务'
)

/* 登录/注册成功：先把站点登录态灌入（避免首页顶栏闪"登录"），
   再用 SPA 路由跳回目标页 —— 不重载文档，因此没有第二段白屏。 */
const handleRegisterSuccess = async () => {
  const redirect = safeRedirect(router.currentRoute.value.query.redirect)
  await loadAuthUser(true)
  try {
    await router.replace(redirect)
  } catch (e) {
    // 路由跳转失败时退回整页跳转，避免停留在加载态
    window.location.assign(redirect)
  }
}

const handleChangeActive = (newValue) => {
  isRegister.value = !newValue
}

onMounted(async () => {
  const { tokengine, message, token, ...restQuery } = route.query
  if (!tokengine) {
    if (token) {
      setUserToken(token)
      handleRegisterSuccess()
    }
    return
  }

  if (tokengine !== 'success') {
    ElMessage.error(typeof message === 'string' ? message : 'Tokengine 登录失败，请重试')
    // 去掉 tokengine/message 参数，让 isHandoff 变 false，显示登录表单供用户重试
    await router.replace({ path: '/login', query: restQuery })
    return
  }

  try {
    const res = await httpPost('/api/user/login/tokengine/complete')
    setUserToken(res.data.token)
    store.setIsLogin(true)
    handleRegisterSuccess()
  } catch (error) {
    ElMessage.error(error.message || 'Tokengine 登录失败，请重试')
    await router.replace({ path: '/login', query: restQuery })
  }
})
</script>

<style scoped>
.login-page,
:global(.login-policy-dialog),
:global(.reset-pass-dialog) {
  --el-color-primary: var(--login-link-color);
  --el-color-primary-light-3: var(--login-link-color);
  --el-color-primary-light-9: var(--login-link-hover-bg);
  --el-color-primary-dark-2: var(--login-primary-hover);
  --el-text-color-primary: var(--login-title-color);
  --el-text-color-regular: var(--login-text-color);
  --el-text-color-secondary: var(--login-subtitle-color);
  --el-text-color-placeholder: var(--login-placeholder-color);
  --el-border-color: var(--login-card-border);
  --el-border-color-light: var(--login-card-border);
  --el-fill-color-blank: var(--login-input-bg);
  --el-fill-color-light: var(--login-soft-bg);
  --el-bg-color: var(--login-card-bg);
  --el-bg-color-overlay: var(--login-card-bg);
  --el-box-shadow: 0 1px 3px rgba(26, 24, 21, 0.08);
  font-family: 'The Future', Arial, 'PingFang SC', 'Microsoft YaHei',
    'Noto Sans SC', system-ui, sans-serif;
  color: var(--login-title-color);
}

.login-page {
  min-height: 100dvh;
  display: flex;
  flex-direction: column;
  background-color: #fff;
  background-image: none;
  background-repeat: no-repeat;
}

.login-header {
  width: 100%;
  max-width: 1280px;
  height: 64px;
  margin: 0 auto;
  padding: 0 32px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-shrink: 0;
}

.login-brand,
.login-back {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: inherit;
  text-decoration: none;
}

.login-brand {
  font-size: 18px;
  font-weight: 600;
  letter-spacing: -0.025em;
}

:global(:root[data-theme='dark'] .login-brand img) {
  filter: invert(1);
}

.login-back {
  margin-bottom: 12px;
  color: var(--login-text-color);
  font-size: 13px;
}

.login-back:hover {
  color: var(--login-link-color);
}

.login-brand:focus-visible,
.login-back:focus-visible {
  outline: 2px solid var(--login-link-color);
  outline-offset: 4px;
  border-radius: 4px;
}

.login-main {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 32px 16px;
}

.login-card {
  width: 100%;
  max-width: 448px;
  margin-bottom: 32px;
  padding: 36px 40px;
  border: 1px solid var(--login-card-border);
  border-radius: 12px;
  background: var(--login-card-bg);
}

.login-intro {
  margin-bottom: 32px;
  text-align: center;
}

.login-page .login-title {
  margin: 0 0 12px;
  font-family: 'The Future', Arial, 'PingFang SC', 'Microsoft YaHei',
    'Noto Sans SC', sans-serif;
  font-size: 36px;
  font-weight: 400;
  letter-spacing: -0.03em;
  line-height: 1.2;
}

.login-page .login-intro p {
  margin: 0;
  font-family: inherit;
  font-size: 14px;
  line-height: 1.7;
  color: var(--login-subtitle-color);
}

.login-footer {
  padding: 16px 16px 24px;
  color: var(--login-subtitle-color);
  font-size: 12px;
  line-height: 1.8;
  text-align: center;
}

:global(.login-policy-dialog),
:global(.reset-pass-dialog) {
  max-width: calc(100vw - 32px);
  border: 1px solid var(--login-card-border);
  border-radius: 12px;
}

:global(.login-policy-dialog) {
  width: 640px;
}

@media (max-width: 480px) {
  .login-header {
    padding: 0 20px;
  }

  .login-main {
    padding: 20px 16px;
  }

  .login-card {
    padding: 28px 24px;
  }

  .login-page .login-title {
    font-size: 32px;
  }

}

/* Tokengine OAuth handoff 覆盖层：与站点画布同色（站点为固定浅色设计），
   让"等待换 token"发生在品牌加载态里，视觉上直接过渡到首页。 */
.handoff-overlay {
  min-height: 100dvh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  background-color: var(--color-canvas, #f7f6f3);
  font-family: 'The Future', Arial, 'PingFang SC', 'Microsoft YaHei',
    'Noto Sans SC', system-ui, sans-serif;
  color: var(--color-ink, #1a1815);
}

.handoff-logo {
  width: 40px;
  height: 40px;
}

.handoff-spinner {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: 3px solid rgba(26, 24, 21, 0.08);
  border-top-color: var(--color-primary, #3b5bdb);
  animation: handoff-spin 0.9s linear infinite;
}

@keyframes handoff-spin {
  to {
    transform: rotate(360deg);
  }
}

.handoff-text {
  margin: 0;
  font-size: 14px;
  line-height: 1.6;
  color: var(--color-muted, #6f6961);
}
</style>
