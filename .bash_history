apt update && apt upgrade -y && adduser --disabled-password --gecos "" novo && usermod -aG sudo novo && mkdir -p /home/novo/.ssh && cp ~/.ssh/authorized_keys /home/novo/.ssh/ && chown -R novo:novo /home/novo/.ssh && chmod 700 /home/novo/.ssh && chmod 600 /home/novo/.ssh/authorized_keys && apt install -y ufw fail2ban && ufw allow OpenSSH && ufw --force enable && sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config && systemctl restart sshd && echo '=== DONE phase A ==='
sshd -T | grep -E "permitrootlogin|passwordauthentication"
bash -lc 'set -e
apt update
DEBIAN_FRONTEND=noninteractive apt install -y nginx
mkdir -p /var/www/darya-english/assets

cat >/var/www/darya-english/index.html <<EOF
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Ai Студия изучения английского языка Дарьи Ершовой</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Cormorant+Garamond:wght@500;600;700&display=swap" rel="stylesheet">
  <style>
    :root{
      --bg:#0c1016;
      --card-bg:rgba(14,19,29,.82);
      --border:rgba(255,255,255,.14);
      --text:#f6efe4;
      --muted:#d3c7b7;
      --accent:#ff4f7d;
    }
    *{box-sizing:border-box;margin:0;padding:0}
    body{
      min-height:100vh;
      display:grid;
      place-items:center;
      font-family:"Manrope",system-ui,sans-serif;
      background:linear-gradient(rgba(6,7,12,.8),rgba(6,7,12,.9)),url(https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?auto=format&fit=crop&w=1800&q=80) center/cover fixed;
      color:var(--text);
      padding:20px;
    }
    .card{
      width:min(1040px,100%);
      background:var(--card-bg);
      border-radius:28px;
      border:1px solid var(--border);
      box-shadow:0 28px 80px rgba(0,0,0,.55);
      padding:32px 28px 30px;
      backdrop-filter:blur(18px);
    }
    .kicker{
      font-size:12px;
      letter-spacing:.16em;
      text-transform:uppercase;
      color:var(--muted);
      margin-bottom:10px;
    }
    h1{
      font-family:"Cormorant Garamond",serif;
      font-size:46px;
      line-height:1.02;
      letter-spacing:-.03em;
      margin-bottom:16px;
    }
    p{
      font-size:18px;
      line-height:1.6;
      color:var(--muted);
      max-width:60ch;
    }
    .row{display:flex;flex-wrap:wrap;gap:12px;margin-top:20px}
    .btn{
      min-height:46px;
      padding:0 22px;
      border-radius:999px;
      display:inline-flex;
      align-items:center;
      justify-content:center;
      font-size:15px;
      text-decoration:none;
    }
    .btn-primary{background:var(--accent);color:#fff}
    .btn-ghost{
      background:transparent;
      color:var(--text);
      border:1px solid var(--border);
    }
    .chips{display:flex;flex-wrap:wrap;gap:10px;margin-top:18px}
    .chip{
      padding:8px 14px;
      border-radius:999px;
      border:1px solid var(--border);
      font-size:13px;
      color:var(--muted);
      background:rgba(0,0,0,.18);
    }
  </style>
</head>
<body>
  <main class="card">
    <div class="kicker">British English • London Style</div>
    <h1>Ai Студия изучения английского языка Дарьи Ершовой</h1>
    <p>Современная London-style AI‑школа британского английского: тест уровня, игровые задания, AI‑наставник, онлайн‑уроки с Дарьей и её командой, подписка и персональные занятия.</p>
    <div class="chips">
      <span class="chip">999 ₽ / месяц • Premium</span>
      <span class="chip">Private от 1500 ₽ / час</span>
      <span class="chip">Ai‑бот с памятью и маршрутами</span>
    </div>
    <div class="row">
      <a class="btn btn-primary" href="#">Пройти тест уровня</a>
      <a class="btn btn-ghost" href="#">Записаться на онлайн‑урок</a>
    </div>
  </main>
</body>
</html>
EOF

cat >/var/www/darya-english/404.html <<EOF
<!DOCTYPE html>
<html lang="ru">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>404</title></head>
<body style="margin:0;min-height:100vh;display:grid;place-items:center;font-family:Arial,sans-serif;background:#0c1016;color:#fff">
  <div style="text-align:center">
    <h1>404</h1>
    <p>Страница не найдена</p>
    <a href="/" style="color:#ff4f7d">На главную</a>
  </div>
</body>
</html>
EOF

cat >/etc/nginx/sites-available/darya-english <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    root /var/www/darya-english;
    index index.html;
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    error_page 404 /404.html;
}
EOF

rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/darya-english /etc/nginx/sites-enabled/darya-english
nginx -t
systemctl enable nginx
systemctl restart nginx

code=\$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1 || true)
echo "LOCAL_HTTP_CODE: \$code"
if [ "\$code" = "200" ]; then echo "все заебись"; else echo "не ок"; fi
'bash -lc 'set -e
cat >/var/www/darya-english/index.html <<EOF
<!DOCTYPE html>
<html lang="ru" data-theme="dark">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1"/>
  <title>Ai Студия изучения английского языка Дарьи Ершовой</title>
  <meta name="description" content="Премиальная London-style AI-школа британского английского: тест уровня, игровые задания, онлайн-уроки с Дарьей Ершовой и её командой, подписка и AI-наставник."/>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Cormorant+Garamond:wght@500;600;700&display=swap" rel="stylesheet">
  <style>
    :root,[data-theme="light"]{
      --text-xs:clamp(.75rem,.7rem + .25vw,.875rem);
      --text-sm:clamp(.875rem,.8rem + .35vw,1rem);
      --text-base:clamp(1rem,.95rem + .25vw,1.125rem);
      --text-lg:clamp(1.125rem,1rem + .75vw,1.5rem);
      --text-xl:clamp(1.5rem,1.2rem + 1.25vw,2.25rem);
      --text-2xl:clamp(2rem,1.2rem + 2.5vw,3.6rem);
      --space-3:.75rem;--space-4:1rem;--space-5:1.25rem;--space-6:1.5rem;--space-8:2rem;--space-10:2.5rem;--space-12:3rem;--space-16:4rem;
      --radius-md:.75rem;--radius-lg:1.2rem;--radius-xl:1.9rem;--radius-full:999px;
      --bg:#0c1016;
      --surface:rgba(14,19,29,.82);
      --surface-soft:rgba(16,22,34,.9);
      --border:rgba(255,255,255,.12);
      --text:#f7f0e4;
      --muted:#d1c7b8;
      --accent:#ff4f7d;
      --accent-soft:rgba(255,79,125,.16);
      --accent-2:#7bc4ff;
      --shadow-md:0 24px 70px rgba(0,0,0,.55);
    }
    [data-theme="dark"]{
      --bg:#05070c;
    }
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    html{scroll-behavior:smooth}
    body{
      min-height:100vh;
      font-family:"Manrope",system-ui,sans-serif;
      background:#05070c;
      color:var(--text);
      overflow-x:hidden;
    }
    img,svg{display:block;max-width:100%;height:auto}
    a{text-decoration:none;color:inherit}
    button{cursor:pointer;border:none;background:none;font:inherit;color:inherit}
    .bg{
      position:fixed;inset:0;z-index:-3;
      background:#05070c;
    }
    .bg::before{
      content:"";position:absolute;inset:0;
      background-image:url("https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?auto=format&fit=crop&w=1920&q=80");
      background-size:cover;background-position:center;
      filter:brightness(.45);
    }
    .bg::after{
      content:"";position:absolute;inset:0;
      background:radial-gradient(circle at 20% 15%,rgba(255,79,125,.28),transparent 55%),
                 radial-gradient(circle at 80% 70%,rgba(123,196,255,.26),transparent 55%);
      mix-blend-mode:screen;opacity:.9;
    }
    .vignette{
      position:fixed;inset:0;z-index:-2;
      background:radial-gradient(circle at 50% 15%,transparent 0,transparent 40%,rgba(0,0,0,.85) 100%);
      pointer-events:none;
    }
    .container{width:min(1140px,100% - 2.4rem);margin:0 auto;}
    header{
      position:sticky;top:0;z-index:20;
      backdrop-filter:blur(18px);
      background:linear-gradient(to bottom,rgba(5,7,12,.9),rgba(5,7,12,.6));
      border-bottom:1px solid rgba(255,255,255,.08);
    }
    .header-inner{
      display:flex;align-items:center;justify-content:space-between;
      padding:.9rem 0;
      gap:var(--space-4);
    }
    .brand{display:flex;align-items:center;gap:var(--space-4);}
    .brand-mark{
      width:52px;height:52px;border-radius:20px;
      background:radial-gradient(circle at 10% 0,rgba(255,79,125,.6),rgba(5,8,16,1));
      display:grid;place-items:center;
      border:1px solid rgba(255,255,255,.16);
      box-shadow:0 18px 45px rgba(0,0,0,.6);
    }
    .brand-mark svg{width:28px;height:28px;color:#fff;}
    .brand-text small{
      font-size:var(--text-xs);
      text-transform:uppercase;
      letter-spacing:.16em;
      color:var(--muted);
    }
    .brand-text strong{
      display:block;margin-top:4px;
      font-size:var(--text-sm);
      max-width:26ch;
    }
    nav ul{display:flex;gap:var(--space-4);list-style:none;align-items:center;flex-wrap:wrap;justify-content:flex-end;}
    nav a{font-size:var(--text-sm);color:var(--muted);}
    .btn{
      display:inline-flex;align-items:center;justify-content:center;
      min-height:42px;
      padding:0 1.4rem;
      border-radius:var(--radius-full);
      font-size:var(--text-sm);
      gap:.35rem;
    }
    .btn-primary{background:var(--accent);color:#fff;}
    .btn-ghost{
      background:transparent;
      color:var(--text);
      border:1px solid rgba(255,255,255,.22);
    }
    main{padding-bottom:var(--space-16);}
    section{padding:var(--space-10) 0;}
    .hero{padding-top:clamp(3.4rem,9vh,5.6rem);}
    .hero-grid{
      display:grid;
      grid-template-columns:minmax(0,1.15fr) minmax(0,.95fr);
      gap:var(--space-8);
      align-items:flex-start;
    }
    .hero-eyebrow{
      font-size:var(--text-xs);
      letter-spacing:.18em;
      text-transform:uppercase;
      color:var(--muted);
      margin-bottom:.4rem;
    }
    h1{
      font-family:"Cormorant Garamond",serif;
      font-size:var(--text-2xl);
      line-height:1;
      letter-spacing:-.03em;
      max-width:13ch;
    }
    .hero p{
      margin-top:var(--space-5);
      font-size:var(--text-lg);
      color:var(--muted);
      max-width:60ch;
    }
    .hero-actions{
      margin-top:var(--space-6);
      display:flex;flex-wrap:wrap;gap:var(--space-3);
    }
    .hero-tags{
      margin-top:var(--space-4);
      display:flex;flex-wrap:wrap;gap:.55rem;
    }
    .pill{
      display:inline-flex;align-items:center;
      padding:.46rem .85rem;
      border-radius:999px;
      border:1px solid rgba(255,255,255,.16);
      background:rgba(3,7,16,.75);
      font-size:var(--text-xs);
      color:var(--muted);
    }
    .card{
      background:var(--surface);
      border-radius:var(--radius-xl);
      border:1px solid var(--border);
      box-shadow:var(--shadow-md);
      padding:var(--space-6);
    }
    .card h2{font-size:var(--text-xl);margin-bottom:var(--space-4);}
    .metric-row{display:flex;flex-wrap:wrap;gap:var(--space-4);margin-top:var(--space-4);}
    .metric{
      flex:1 1 130px;
      padding:var(--space-4);
      border-radius:var(--radius-lg);
      background:var(--surface-soft);
      border:1px solid rgba(255,255,255,.12);
    }
    .metric strong{font-size:var(--text-lg);}
    .metric span{display:block;font-size:var(--text-xs);color:var(--muted);}
    .section-head{
      display:flex;justify-content:space-between;gap:var(--space-4);
      align-items:flex-end;flex-wrap:wrap;margin-bottom:var(--space-6);
    }
    .section-head h2{font-size:var(--text-xl);}
    .section-head p{max-width:46ch;color:var(--muted);}
    .badge{
      display:inline-flex;padding:.42rem .9rem;
      border-radius:999px;
      font-size:var(--text-xs);
      letter-spacing:.12em;
      text-transform:uppercase;
      border:1px solid rgba(255,255,255,.14);
      background:rgba(3,7,16,.88);
      color:var(--muted);
    }
    .grid-4,.grid-3{
      display:grid;
      gap:var(--space-4);
    }
    .grid-4{grid-template-columns:repeat(4,minmax(0,1fr));}
    .grid-3{grid-template-columns:repeat(3,minmax(0,1fr));}
    .feature{
      padding:var(--space-4);
      border-radius:var(--radius-lg);
      background:var(--surface);
      border:1px solid rgba(255,255,255,.12);
    }
    .feature h3{margin-bottom:.35rem;font-size:var(--text-base);}
    .feature p{font-size:var(--text-sm);color:var(--muted);}
    .feature span.step{font-size:var(--text-xs);color:var(--muted);text-transform:uppercase;letter-spacing:.16em;}
    .split{
      display:grid;
      grid-template-columns:minmax(0,1.15fr) minmax(0,.9fr);
      gap:var(--space-6);
      align-items:flex-start;
    }
    .quiz-q{margin-top:var(--space-4);}
    .quiz-q h3{font-size:var(--text-lg);margin-bottom:var(--space-3);}
    .quiz-options{display:grid;gap:var(--space-3);}
    .quiz-option{
      padding:var(--space-4);
      border-radius:var(--radius-lg);
      background:var(--surface-soft);
      border:1px solid rgba(255,255,255,.14);
      font-size:var(--text-sm);
      display:flex;gap:.75rem;align-items:flex-start;
      cursor:pointer;
    }
    .quiz-option[data-state="active"]{
      border-color:var(--accent);
      background:var(--accent-soft);
    }
    .quiz-option span.index{
      font-size:var(--text-xs);
      color:var(--muted);
      margin-top:.1rem;
    }
    .quiz-meta{font-size:var(--text-xs);color:var(--muted);}
    .btn-row{display:flex;flex-wrap:wrap;gap:var(--space-3);margin-top:var(--space-4);}
    .result-box{
      margin-top:var(--space-4);
      padding:var(--space-4);
      border-radius:var(--radius-lg);
      background:linear-gradient(135deg,rgba(255,79,125,.18),rgba(123,196,255,.18));
      border:1px solid rgba(255,255,255,.24);
    }
    .level-bar{display:flex;gap:.3rem;margin-top:.5rem;}
    .level-bar span{
      flex:1;height:9px;border-radius:999px;
      background:rgba(0,0,0,.28);
    }
    .level-bar span.on{
      background:linear-gradient(90deg,var(--accent),var(--accent-2));
    }
    .game-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:var(--space-4);}
    .game-card{
      border-radius:var(--radius-lg);
      padding:var(--space-4);
      background:var(--surface);
      border:1px solid rgba(255,255,255,.12);
    }
    .scene{
      border-radius:var(--radius-md);
      overflow:hidden;
      border:1px solid rgba(255,255,255,.16);
      margin-bottom:var(--space-3);
      position:relative;
      background-size:cover;background-position:center;
      aspect-ratio:4/3;
    }
    .scene::after{
      content:attr(data-caption);
      position:absolute;left:0;right:0;bottom:0;
      padding:.55rem .8rem;
      font-size:var(--text-xs);
      background:linear-gradient(to top,rgba(0,0,0,.86),transparent);
    }
    .scene[data-s="tea"]{background-image:url("https://images.unsplash.com/photo-1514933651103-005eec06c04b?auto=format&fit=crop&w=900&q=80");}
    .scene[data-s="tube"]{background-image:url("https://images.unsplash.com/photo-1526137913816-358b99c583b3?auto=format&fit=crop&w=900&q=80");}
    .scene[data-s="museum"]{background-image:url("https://images.unsplash.com/photo-1514933651103-005eec06c04b?auto=format&fit=crop&w=900&q=80");filter:saturate(1.2);}
    .price-card{
      padding:var(--space-5);
      border-radius:var(--radius-lg);
      background:var(--surface);
      border:1px solid rgba(255,255,255,.16);
    }
    .price-card.highlight{
      border-color:var(--accent);
      background:radial-gradient(circle at 0 0,rgba(255,79,125,.26),rgba(10,12,20,.9));
    }
    .price{
      font-size:1.8rem;
      margin:var(--space-3) 0 .25rem;
    }
    .price-card p{color:var(--muted);font-size:var(--text-sm);}
    .badge-inline{font-size:var(--text-xs);color:var(--muted);}
    .lesson-grid{display:grid;grid-template-columns:minmax(0,1.1fr) minmax(0,.9fr);gap:var(--space-6);}
    .lesson-list{display:grid;gap:var(--space-4);}
    .lesson{
      padding:var(--space-4);
      border-radius:var(--radius-lg);
      background:var(--surface);
      border:1px solid rgba(255,255,255,.16);
      display:flex;justify-content:space-between;gap:var(--space-3);flex-wrap:wrap;
    }
    .lesson-time{font-family:"Cormorant Garamond",serif;font-size:1.4rem;}
    .lesson strong{display:block;}
    .lesson small{display:block;color:var(--muted);font-size:var(--text-xs);}
    .chat{
      padding:var(--space-5);
      border-radius:var(--radius-xl);
      background:var(--surface);
      border:1px solid rgba(255,255,255,.16);
      display:grid;gap:var(--space-4);
    }
    .chat-window{
      padding:var(--space-4);
      border-radius:var(--radius-lg);
      background:rgba(4,8,16,.92);
      max-height:260px;
      overflow:auto;
      display:flex;flex-direction:column;gap:var(--space-3);
      border:1px solid rgba(255,255,255,.12);
    }
    .bubble{
      max-width:76%;
      padding:var(--space-3);
      border-radius:1.4rem;
      font-size:var(--text-sm);
    }
    .bubble.ai{
      background:rgba(45,61,96,.98);
      align-self:flex-start;
    }
    .bubble.user{
      background:var(--accent);
      align-self:flex-end;
    }
    .chat-form{
      display:flex;gap:.6rem;
      align-items:center;
    }
    .chat-input{
      flex:1;
      padding:.75rem .9rem;
      border-radius:var(--radius-full);
      border:1px solid rgba(255,255,255,.2);
      background:rgba(5,10,18,.9);
      color:var(--text);
      font-size:var(--text-sm);
    }
    .chat-send{
      min-height:40px;
      padding:0 1.2rem;
      border-radius:var(--radius-full);
      background:var(--accent);
      color:#fff;
      font-size:var(--text-sm);
    }
    .cta-final{
      padding:var(--space-8);
      border-radius:var(--radius-xl);
      background:radial-gradient(circle at 0 0,rgba(255,79,125,.32),rgba(3,6,14,.96));
      border:1px solid rgba(255,255,255,.18);
      display:flex;flex-wrap:wrap;justify-content:space-between;gap:var(--space-4);
      align-items:center;
    }
    footer{
      padding:var(--space-6) 0 var(--space-8);
      border-top:1px solid rgba(255,255,255,.12);
      background:rgba(5,7,12,.96);
    }
    footer p{color:var(--muted);font-size:var(--text-xs);}
    @media (max-width:960px){
      .hero-grid,.split,.game-grid,.lesson-grid{grid-template-columns:1fr;}
      .grid-4{grid-template-columns:repeat(2,minmax(0,1fr));}
      .grid-3{grid-template-columns:repeat(2,minmax(0,1fr));}
      .header-inner{flex-direction:column;align-items:flex-start;}
      .hero-actions{flex-direction:column;align-items:flex-start;}
      .cta-final{flex-direction:column;align-items:flex-start;}
    }
    @media (max-width:640px){
      .grid-4,.grid-3,.game-grid{grid-template-columns:1fr;}
      .card,.chat,.price-card,.lesson,.cta-final{padding:1.2rem;}
      section{padding:2.3rem 0;}
      .hero{padding-top:2.3rem;}
    }
  </style>
</head>
<body>
<div class="bg"></div>
<div class="vignette"></div>

<header>
  <div class="container header-inner">
    <div class="brand">
      <div class="brand-mark" aria-hidden="true">
        <svg viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg" fill="none">
          <path d="M12 50V14H34C44.5 14 53 22.5 53 33C53 43.5 44.5 52 34 52H12Z" stroke="white" stroke-width="4.2" stroke-linejoin="round"/>
          <path d="M25 23L38 33L25 43" stroke="white" stroke-width="4.2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
      <div class="brand-text">
        <small>British English • London Style</small>
        <strong>Ai Студия изучения английского языка Дарьи Ершовой</strong>
      </div>
    </div>
    <nav aria-label="Главная навигация">
      <ul>
        <li><a href="#how">Как это работает</a></li>
        <li><a href="#test">Тест</a></li>
        <li><a href="#game">Game mode</a></li>
        <li><a href="#pricing">Тарифы</a></li>
        <li><a href="#lessons">Уроки</a></li>
        <li><a href="#bot">AI‑бот</a></li>
        <li><a class="btn btn-primary" href="#test">Пройти тест</a></li>
      </ul>
    </nav>
  </div>
</header>

<main>
  <section class="hero" id="hero">
    <div class="container hero-grid">
      <div>
        <div class="hero-eyebrow">London calling • Speak beautifully</div>
        <h1>Британский английский как шаг в новый уровень речи и статуса.</h1>
        <p>Ai‑студия Дарьи Ершовой — это тест уровня, игровая практика, AI‑наставник и живые уроки, собранные в одну понятную систему. Диагностика, маршрут, поддержка и результат — в одном месте.</p>
        <div class="hero-actions">
          <a class="btn btn-primary" href="#test">Start level test</a>
          <a class="btn btn-ghost" href="#lessons">Записаться на урок с Дарьей</a>
        </div>
        <div class="hero-tags">
          <span class="pill">999 ₽ / месяц • Premium</span>
          <span class="pill">Private от 1500 ₽ / час</span>
          <span class="pill">AI memory для каждого ученика</span>
        </div>
      </div>
      <aside class="card">
        <span class="badge">Student journey</span>
        <h2>От диагностики до привычки учиться каждый день.</h2>
        <p class="quiz-meta">Система строит путь вокруг реальных задач: speaking, grammar, словарь и культурный фон British English.</p>
        <div class="metric-row">
          <div class="metric">
            <span>Уровень</span>
            <strong>B1</strong>
            <span>Independent user</span>
          </div>
          <div class="metric">
            <span>Серия</span>
            <strong>14</strong>
            <span>дней подряд</span>
          </div>
          <div class="metric">
            <span>След. урок</span>
            <strong>19:00</strong>
            <span>с Дарьей</span>
          </div>
        </div>
      </aside>
    </div>
  </section>

  <section id="how">
    <div class="container">
      <div class="section-head">
        <div>
          <span class="badge">Как это работает</span>
          <h2>Одна воронка: тест, AI‑маршрут, игра, подписка, живые уроки.</h2>
        </div>
        <p>Главная страница ведёт человека от первого интереса к осознанному решению: как он будет учить английский дальше — через игру, подписку или private урок.</p>
      </div>
      <div class="grid-4">
        <article class="feature">
          <span class="step">01 • Placement test</span>
          <h3>Определяем уровень</h3>
          <p>Короткий, но точный тест по академической градации A1–C2.</p>
        </article>
        <article class="feature">
          <span class="step">02 • AI route</span>
          <h3>Строим маршрут</h3>
          <p>Ai‑бот запоминает ответы, интересы, скорость и формирует план.</p>
        </article>
        <article class="feature">
          <span class="step">03 • Game mode</span>
          <h3>Учёба через ситуации</h3>
          <p>Лексика и грамматика в живых сценах London life.</p>
        </article>
        <article class="feature">
          <span class="step">04 • Live lessons</span>
          <h3>Закрепляем прорыв</h3>
          <p>Дарья и команда разбирают тонкости и доводят до уверенной речи.</p>
        </article>
      </div>
    </div>
  </section>

  <section id="test">
    <div class="container split">
      <article class="card">
        <span class="badge">Placement test</span>
        <h2>Тест уровня, который сразу показывает следующий шаг.</h2>
        <p class="quiz-meta">После четырёх вопросов вы получаете уровень и рекомендацию: играть, переходить в подписку или сразу записаться на урок.</p>
        <div class="quiz-q">
          <div class="quiz-meta" id="q-meta">Вопрос 1 из 4</div>
          <h3 id="q-text">Выберите корректное предложение:</h3>
          <div class="quiz-options" id="q-options"></div>
          <div class="btn-row">
            <button type="button" class="btn btn-primary" id="q-next">Далее</button>
            <button type="button" class="btn btn-ghost" id="q-reset">Сбросить</button>
          </div>
        </div>
      </article>
      <aside class="card">
        <span class="badge">Результат</span>
        <h2 id="res-title">Пример результата: B1 — Independent user</h2>
        <p id="res-text">Комфортно общаетесь в бытовых ситуациях, готовы перейти к красивой, более точной речи в британском стиле.</p>
        <div class="result-box">
          <div class="quiz-meta">Уровни A1–C2</div>
          <div class="level-bar" id="res-bar">
            <span class="on"></span><span class="on"></span><span class="on"></span><span></span><span></span><span></span>
          </div>
        </div>
        <div class="btn-row" style="margin-top:var(--space-5);">
          <a class="btn btn-primary" href="#game">Открыть задания под мой уровень</a>
          <a class="btn btn-ghost" href="#pricing">Посмотреть тарифы</a>
        </div>
      </aside>
    </div>
  </section>

  <section id="game">
    <div class="container">
      <div class="section-head">
        <div>
          <span class="badge">Game mode</span>
          <h2>Игровая подача, серьёзный английский.</h2>
        </div>
      </div>
      <div class="game-grid">
        <article class="game-card">
          <div class="scene" data-s="tea" data-caption="A2 • Order tea and scones politely"></div>
          <h3>Grammar in action</h3>
          <p>Вместо абстрактных правил — сцена в лондонском кафе, где ошибка сразу слышна и понятна.</p>
        </article>
        <article class="game-card">
          <div class="scene" data-s="tube" data-caption="B1 • Ask for directions at the Underground"></div>
          <h3>Real situations</h3>
          <p>Каждое задание — маленький диалог: вы слышите, читаете и отвечаете, а AI подсказывает лучшее выражение.</p>
        </article>
        <article class="game-card">
          <div class="scene" data-s="museum" data-caption="C1 • Talk about art and culture"></div>
          <h3>High-level thinking</h3>
          <p>На продвинутых уровнях — темы искусства, литературы, политики в формате умных разговоров.</p>
        </article>
      </div>
    </div>
  </section>

  <section id="pricing">
    <div class="container">
      <div class="section-head">
        <div>
          <span class="badge">Тарифы</span>
          <h2>Войти легко, остаться выгодно, усилиться персонально.</h2>
        </div>
      </div>
      <div class="grid-3">
        <article class="price-card">
          <span class="badge-inline">Free start</span>
          <div class="price">0 ₽</div>
          <p>Тест, демо‑игра и знакомство с AI‑ботом.</p>
        </article>
        <article class="price-card highlight">
          <span class="badge-inline">Premium • 999 ₽ / месяц</span>
          <div class="price">Основной формат</div>
          <p>Регулярные задания, AI‑маршрут, сопровождение и живые тематические разборы.</p>
          <div class="btn-row" style="margin-top:var(--space-4);">
            <a class="btn btn-primary" href="#lessons">Перейти на Premium</a>
          </div>
        </article>
        <article class="price-card">
          <span class="badge-inline">Private lesson</span>
          <div class="price">от 1500 ₽ / час</div>
          <p>Персональная работа с Дарьей или преподавателем команды под вашу цель.</p>
        </article>
      </div>
    </div>
  </section>

  <section id="lessons">
    <div class="container lesson-grid">
      <div>
        <div class="section-head">
          <div>
            <span class="badge">Онлайн‑уроки</span>
            <h2>Живое общение, где вы чувствуете прогресс в голосе.</h2>
          </div>
        </div>
        <div class="lesson-list">
          <article class="lesson">
            <div>
              <span class="lesson-time">19:00</span>
              <strong>Дарья • Pronunciation clinic</strong>
              <small>Постановка британского звучания, ритм и интонация.</small>
            </div>
            <a class="btn btn-primary" href="#bot">Подобрать слот</a>
          </article>
          <article class="lesson">
            <div>
              <span class="lesson-time">13:00</span>
              <strong>Team • Grammar lab</strong>
              <small>Глубокий разбор времён и структуры речи на реальных текстах.</small>
            </div>
            <a class="btn btn-ghost" href="#bot">Написать боту</a>
          </article>
        </div>
      </div>
      <aside class="price-card">
        <span class="badge-inline">Как это работает</span>
        <p style="margin-top:var(--space-3);">После теста и первых заданий AI‑бот предлагает время урока, исходя из вашего уровня, целей и расписания преподавателей.</p>
      </aside>
    </div>
  </section>

  <section id="bot">
    <div class="container split">
      <article class="chat">
        <span class="badge">AI‑бот</span>
        <h2>Наставник, консультант и продавец следующего шага — в одном лице.</h2>
        <div class="chat-window" id="chatWindow">
          <div class="bubble ai">
            Good evening! Я вижу, что вы уверенно держите уровень B1. Хотите speaking‑challenge, план на месяц или подобрать урок с Дарьей?
          </div>
          <div class="bubble user">
            Хочу говорить красиво и без пауз.
          </div>
          <div class="bubble ai">
            Тогда начнём с short London stories, а затем предложу вам лучший формат: Premium + 1 раз в неделю private.
          </div>
        </div>
        <form class="chat-form" onsubmit="event.preventDefault();fakeReply();">
          <input id="chatInput" class="chat-input" placeholder="Спросите: какой у меня уровень, сколько стоит, какой формат выбрать">
          <button class="chat-send" type="submit">Отправить</button>
        </form>
      </article>
      <aside class="card">
        <span class="badge">Что умеет бот</span>
        <p style="margin-top:var(--space-3);">AI‑ассистент, интегрированный с Claude, запоминает ваши ответы, фиксирует сильные и слабые стороны и мягко подталкивает к следующему шагу — от игры к подписке и урокам.</p>
        <ul style="margin-top:var(--space-4);list-style:none;padding-left:0;font-size:var(--text-sm);color:var(--muted);display:grid;gap:.4rem;">
          <li>• Soft onboarding: регистрация, первый маршрут, ответы на вопросы.</li>
          <li>• Memory profile: хранит ваш прогресс и любимые темы.</li>
          <li>• Task adaptation: усложняет задания, когда вы готовы.</li>
          <li>• Lesson booking: помогает выбрать слот и оплатить.</li>
        </ul>
      </aside>
    </div>
  </section>

  <section id="cta">
    <div class="container">
      <div class="cta-final">
        <div>
          <span class="badge">Start today</span>
          <h2 style="font-size:var(--text-xl);margin-top:var(--space-3);">Сделайте английский частью жизни, а не списком задач.</h2>
          <p style="margin-top:var(--space-3);max-width:46ch;color:var(--muted);">Пройдите тест, получите маршрут и почувствуйте, как британский английский постепенно становится вашим инструментом — для путешествий, карьеры и удовольствия.</p>
        </div>
        <div class="hero-actions" style="margin-top:0;">
          <a class="btn btn-primary" href="#test">Пройти тест уровня</a>
          <a class="btn btn-ghost" href="#lessons">Выбрать урок с Дарьей</a>
        </div>
      </div>
    </div>
  </section>
</main>

<footer>
  <div class="container">
    <p>© Ai Студия изучения английского языка Дарьи Ершовой. London‑style British English • Online.</p>
  </div>
</footer>

<script>
  const questions = [
    {
      text: "Choose the correct sentence:",
      options: [
        "I am living in London for five years.",
        "I have been living in London for five years.",
        "I live in London since five years."
      ],
      correct: 1
    },
    {
      text: "Выберите естественный вариант:",
      options: [
        "Can you tell me where is the station?",
        "Can you tell me where the station is?",
        "Can you say me where the station is?"
      ],
      correct: 1
    },
    {
      text: "Complete the sentence:",
      options: [
        "If I would have more time, I study English every day.",
        "If I had more time, I would study English every day.",
        "If I will have more time, I would study English every day."
      ],
      correct: 1
    },
    {
      text: "Что звучит по‑британски вежливо?",
      options: [
        "I want a cup of tea.",
        "Give me a cup of tea.",
        "Could I have a cup of tea, please?"
      ],
      correct: 2
    }
  ];
  let current = 0;
  let score = 0;
  let selected = null;

  const metaEl = document.getElementById("q-meta");
  const textEl = document.getElementById("q-text");
  const optsEl = document.getElementById("q-options");
  const nextBtn = document.getElementById("q-next");
  const resetBtn = document.getElementById("q-reset");
  const resTitle = document.getElementById("res-title");
  const resText = document.getElementById("res-text");
  const resBar = document.getElementById("res-bar");

  function renderQuestion() {
    const q = questions[current];
    metaEl.textContent = "Вопрос " + (current + 1) + " из " + questions.length;
    textEl.textContent = q.text;
    optsEl.innerHTML = "";
    selected = null;
    q.options.forEach((opt, idx) => {
      const btn = document.createElement("button");
      btn.type = "button";
      btn.className = "quiz-option";
      btn.dataset.index = idx;
      btn.innerHTML = '<span class="index">' + String.fromCharCode(65+idx) + ".</span><div>" + opt + "</div>";
      btn.addEventListener("click", () => {
        selected = idx;
        document.querySelectorAll(".quiz-option").forEach(o => o.dataset.state = "");
        btn.dataset.state = "active";
      });
      optsEl.appendChild(btn);
    });
    nextBtn.textContent = current === questions.length - 1 ? "Завершить" : "Далее";
  }

  function updateResult() {
    const levelSpans = resBar.querySelectorAll("span");
    levelSpans.forEach(s => s.classList.remove("on"));
    let level, desc, onCount;
    if (score <= 1) {
      level = "A2 — Elementary";
      desc = "Хорошая база для того, чтобы через игру и Premium выйти в уверенный B1.";
      onCount = 2;
    } else if (score === 2) {
      level = "B1 — Independent user";
      desc = "Вы уверенно держите разговор в типичных ситуациях. Время прокачать стиль и скорость речи.";
      onCount = 3;
    } else if (score === 3) {
      level = "B2 — Upper‑intermediate";
      desc = "Можно уходить в сложные темы и обсуждать идеи. Отличная база для международных задач.";
      onCount = 4;
    } else {
      level = "C1 — Advanced";
      desc = "Вы близки к свободному владению. Дальше — оттачивание нюансов и акцента с Дарьей.";
      onCount = 5;
    }
    resTitle.textContent = "Ваш примерный уровень: " + level;
    resText.textContent = desc;
    for(let i=0;i<onCount && i<levelSpans.length;i++){levelSpans[i].classList.add("on");}
  }

  nextBtn.addEventListener("click", () => {
    if (selected === null) return;
    if (selected === questions[current].correct) score++;
    if (current < questions.length - 1) {
      current++;
      renderQuestion();
    } else {
      updateResult();
    }
  });

  resetBtn.addEventListener("click", () => {
    current = 0;score = 0;renderQuestion();
  });

  function fakeReply() {
    const input = document.getElementById("chatInput");
    const text = input.value.trim();
    if (!text) return;
    const win = document.getElementById("chatWindow");
    const userB = document.createElement("div");
    userB.className = "bubble user";
    userB.textContent = text;
    win.appendChild(userB);
    input.value = "";
    setTimeout(() => {
      const ai = document.createElement("div");
      ai.className = "bubble ai";
      ai.textContent = "Я зафиксировал, что для вас важно: «" + text + "». На основе результата теста предложу лучший формат — Premium + подходящий слот для уроков.";
      win.appendChild(ai);
      win.scrollTop = win.scrollHeight;
    }, 600);
  }

  renderQuestion();
</script>
</body>
</html>
EOF

nginx -t
systemctl restart nginx
code=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1 || true)
echo "LOCAL_HTTP_CODE: $code"
if [ "$code" = "200" ]; then echo "все заебись"; else echo "не ок"; fi
'
bash -lc 'code=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1 || true); title=$(curl -s http://127.0.0.1 | grep -o "<title>.*</title>" | head -n 1 || true); if [ -f /var/www/darya-english/index.html ] && nginx -t >/dev/null 2>&1 && systemctl -q is-active nginx && [ "$code" = "200" ]; then echo "все заебись"; echo "$title"; else echo "не ок"; echo "--- files ---"; ls -lah /var/www/darya-english 2>/dev/null || true; echo "--- nginx test ---"; nginx -t 2>&1 || true; echo "--- nginx status ---"; systemctl status nginx --no-pager -l | tail -n 20 || true; echo "--- http code ---"; echo "$code"; echo "--- title ---"; echo "$title"; fi'bash -lc 'code=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1" || true); title=$(curl -s "http://127.0.0.1" | grep -o "<title>.*</title>" | head -n 1 || true); if [ -f /var/www/darya-english/index.html ] && nginx -t >/dev/null 2>&1 && systemctl -q is-active nginx && [ "$code" = "200" ]; then echo "все заебись"; echo "$title"; else echo "не ок"; echo "--- files ---"; ls -lah /var/www/darya-english 2>/dev/null || true; echo "--- nginx test ---"; nginx -t 2>&1 || true; echo "--- nginx status ---"; systemctl status nginx --no-pager -l | tail -n 20 || true; echo "--- http code ---"; echo "$code"; echo "--- title ---"; echo "$title"; fi'
root@nsk-1-vm-iutf:~# bash -lc 'code=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1 || true); title=$(curl -s http://127.0.0.1 | grep -o "<title>.*</title>" | head -n 1 || true); if [ -f /var/www/darya-english/index.html ] && nginx -t >/dev/null 2>&1 && systemctl -q is-active nginx && [ "$code" = "200" ]; then echo "все заебись"; echo "$title"; else echo "не ок"; echo "--- files ---"; ls -lah /var/www/darya-english 2>/dev/null || true; echo "--- nginx test ---"; nginx -t 2>&1 || true; echo "--- nginx status ---"; systemctl status nginx --no-pager -l | tail -n 20 || true; echo "--- http code ---"; echo "$code"; echo "--- title ---"; echo "$title"; fi'bash -lc 'code=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1" || true); title=$(curl -s "http://127.0.0.1" | grep -o "<title>.*</title>" | head -n 1 || true); if [ -f /var/www/darya-english/index.html ] && nginx -t >/dev/null 2>&1 && systemctl -q is-active nginx && [ "$code" = "200" ]; then echo "все заебись"; echo "$title"; else echo "не ок"; echo "--- files ---"; ls -lah /var/www/darya-english 2>/dev/null || true; echo "--- nginx test ---"; nginx -t 2>&1 || true; echo "--- nginx status ---"; systemctl status nginx --no-pager -l | tail -n 20 || true; echo "--- http code ---"; echo "$code"; echo "--- title ---"; echo "$title"; fi'
bash -lc 'code=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1" || true); title=$(curl -s "http://127.0.0.1" | grep -o "<title>.*</title>" | head -n 1 || true); if [ -f /var/www/darya-english/index.html ] && nginx -t >/dev/null 2>&1 && systemctl -q is-active nginx && [ "$code" = "200" ]; then echo "🟢🟢🟢"; echo "$title"; else echo "🔴 НЕ ОК"; echo "--- files ---"; ls -lah /var/www/darya-english 2>/dev/null || true; echo "--- nginx test ---"; nginx -t 2>&1 || true; echo "--- nginx status ---"; systemctl status nginx --no-pager -l | tail -n 20 || true; echo "--- http code ---"; echo "$code"; echo "--- title ---"; echo "$title"; fi'
bash -lc 'ufw allow ssh >/dev/null 2>&1 || true; ufw allow 80/tcp >/dev/null 2>&1 || true; ufw allow 443/tcp >/dev/null 2>&1 || true; echo "IP: $(hostname -I | awk "{print \$1}")"; echo "--- UFW STATUS ---"; ufw status || true; echo "--- LISTEN 80 ---"; ss -ltnp | grep ":80" || true; code=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1" || true); if [ "$code" = "200" ]; then echo "🟢🟢🟢"; else echo "🔴 НЕ ОК"; fi'
bash -lc 'echo "PUBLIC_IP: 186.246.31.45"; echo "--- LOCAL CHECK ---"; curl -I "http://127.0.0.1" | head -n 5; echo "--- PUBLIC IP CHECK FROM SERVER ---"; curl -I "http://186.246.31.45" | head -n 5; echo "--- LISTEN ---"; ss -ltnp | grep ":80" || true; echo "--- NGINX SERVER BLOCKS ---"; nginx -T 2>/dev/null | grep -E "listen 80|server_name|root /var/www/darya-english"'
bash -lc 'cat >/var/www/darya-english/index.html <<EOF
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Ai Студия изучения английского языка Дарьи Ершовой</title>
  <style>
    *{box-sizing:border-box;margin:0;padding:0}
    body{
      min-height:100vh;
      display:grid;
      place-items:center;
      padding:24px;
      font-family:Arial,sans-serif;
      background:
        radial-gradient(circle at 20% 20%, rgba(255,79,125,.28), transparent 35%),
        radial-gradient(circle at 80% 70%, rgba(123,196,255,.22), transparent 35%),
        linear-gradient(135deg, #0b0f17, #121a28 45%, #1c1020 100%);
      color:#f6efe4;
    }
    .card{
      width:min(980px,100%);
      background:rgba(14,19,29,.82);
      border:1px solid rgba(255,255,255,.12);
      border-radius:28px;
      padding:40px 28px;
      box-shadow:0 24px 70px rgba(0,0,0,.45);
      backdrop-filter:blur(12px);
    }
    .kicker{
      font-size:12px;
      letter-spacing:.16em;
      text-transform:uppercase;
      color:#d7cdbf;
      margin-bottom:12px;
    }
    h1{
      font-size:48px;
      line-height:1.02;
      margin-bottom:18px;
    }
    p{
      font-size:20px;
      line-height:1.6;
      color:#d7cdbf;
      max-width:60ch;
    }
    .row{display:flex;gap:12px;flex-wrap:wrap;margin-top:26px}
    .btn{
      display:inline-flex;
      align-items:center;
      justify-content:center;
      min-height:46px;
      padding:0 22px;
      border-radius:999px;
      text-decoration:none;
      font-size:15px;
    }
    .primary{background:#ff4f7d;color:#fff}
    .ghost{border:1px solid rgba(255,255,255,.16);color:#fff}
    .chips{display:flex;flex-wrap:wrap;gap:10px;margin-top:18px}
    .chip{
      padding:9px 14px;
      border-radius:999px;
      border:1px solid rgba(255,255,255,.12);
      color:#d7cdbf;
      font-size:13px;
      background:rgba(255,255,255,.04);
    }
  </style>
</head>
<body>
  <main class="card">
    <div class="kicker">British English • London Style</div>
    <h1>Ai Студия изучения английского языка Дарьи Ершовой</h1>
    <p>Современная AI‑платформа для изучения британского английского: тест уровня, игровые задания, онлайн‑уроки, premium‑подписка и сопровождение Дарьи и её команды.</p>
    <div class="chips">
      <span class="chip">999 ₽ / месяц</span>
      <span class="chip">Private от 1500 ₽ / час</span>
      <span class="chip">AI memory и персональный маршрут</span>
    </div>
    <div class="row">
      <a class="btn primary" href="#">Пройти тест уровня</a>
      <a class="btn ghost" href="#">Записаться на урок</a>
    </div>
  </main>
</body>
</html>
EOF
systemctl restart nginx
curl -I http://127.0.0.1 | head -n 5'
bash -lc 'mkdir -p /var/www/darya-english/assets && cat >/var/www/darya-english/index.html <<EOF
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Ai Студия изучения английского языка Дарьи Ершовой</title>
  <meta name="description" content="British English, AI-обучение, тест уровня, игровые задания, онлайн-уроки с Дарьей Ершовой и её командой.">
  <style>
    :root{
      --bg:#0b0f17;
      --bg2:#151c29;
      --card:rgba(16,22,34,.84);
      --stroke:rgba(255,255,255,.12);
      --text:#f6efe4;
      --muted:#d5cab9;
      --accent:#ff4f7d;
      --accent2:#7bc4ff;
    }
    *{box-sizing:border-box;margin:0;padding:0}
    body{
      min-height:100vh;
      font-family:Arial,sans-serif;
      color:var(--text);
      background:
        radial-gradient(circle at 15% 20%, rgba(255,79,125,.22), transparent 32%),
        radial-gradient(circle at 80% 70%, rgba(123,196,255,.18), transparent 30%),
        linear-gradient(135deg, var(--bg), var(--bg2) 50%, #1b1020 100%);
    }
    .wrap{width:min(1180px,calc(100% - 24px));margin:0 auto}
    header{
      position:sticky;top:0;z-index:5;
      backdrop-filter:blur(14px);
      background:rgba(8,11,18,.72);
      border-bottom:1px solid rgba(255,255,255,.08);
    }
    .head{
      display:flex;justify-content:space-between;align-items:center;gap:16px;
      padding:16px 0;flex-wrap:wrap;
    }
    .brand strong{display:block;font-size:15px}
    .brand small{display:block;font-size:12px;color:var(--muted);letter-spacing:.14em;text-transform:uppercase}
    nav{display:flex;gap:10px;flex-wrap:wrap}
    nav a{
      color:var(--muted);
      text-decoration:none;
      font-size:14px;
      padding:10px 14px;
      border-radius:999px;
      border:1px solid transparent;
    }
    nav a.cta{
      background:var(--accent);
      color:#fff;
    }
    .hero{
      display:grid;
      grid-template-columns:1.1fr .9fr;
      gap:24px;
      align-items:start;
      padding:48px 0 28px;
    }
    .panel,.card{
      background:var(--card);
      border:1px solid var(--stroke);
      border-radius:28px;
      box-shadow:0 24px 70px rgba(0,0,0,.35);
      backdrop-filter:blur(14px);
    }
    .panel{padding:36px 28px}
    .eyebrow{
      font-size:12px;
      letter-spacing:.16em;
      text-transform:uppercase;
      color:var(--muted);
      margin-bottom:10px;
    }
    h1{
      font-size:54px;
      line-height:1.02;
      margin-bottom:18px;
      max-width:12ch;
    }
    p.lead{
      font-size:20px;
      line-height:1.6;
      color:var(--muted);
      max-width:60ch;
    }
    .row{display:flex;gap:12px;flex-wrap:wrap;margin-top:24px}
    .btn{
      min-height:46px;
      padding:0 20px;
      border-radius:999px;
      display:inline-flex;
      align-items:center;
      justify-content:center;
      text-decoration:none;
      font-size:15px;
    }
    .btn-primary{background:var(--accent);color:#fff}
    .btn-ghost{border:1px solid var(--stroke);color:#fff}
    .chips{display:flex;flex-wrap:wrap;gap:10px;margin-top:18px}
    .chip{
      padding:9px 14px;
      border-radius:999px;
      background:rgba(255,255,255,.04);
      border:1px solid var(--stroke);
      color:var(--muted);
      font-size:13px;
    }
    .card{padding:24px}
    .card h2{font-size:28px;margin-bottom:12px}
    .muted{color:var(--muted)}
    .stats{display:grid;grid-template-columns:repeat(2,1fr);gap:12px;margin-top:20px}
    .stat{
      padding:16px;
      border-radius:20px;
      background:rgba(255,255,255,.04);
      border:1px solid var(--stroke);
    }
    .stat strong{display:block;font-size:24px}
    section{padding:18px 0}
    .section-head{display:flex;justify-content:space-between;gap:16px;align-items:end;flex-wrap:wrap;margin-bottom:18px}
    .section-head h2{font-size:34px}
    .badge{
      display:inline-flex;
      padding:8px 12px;
      border-radius:999px;
      border:1px solid var(--stroke);
      color:var(--muted);
      font-size:12px;
      text-transform:uppercase;
      letter-spacing:.12em;
      margin-bottom:10px;
    }
    .grid3,.grid4{display:grid;gap:14px}
    .grid3{grid-template-columns:repeat(3,1fr)}
    .grid4{grid-template-columns:repeat(4,1fr)}
    .box{
      padding:18px;
      border-radius:22px;
      background:var(--card);
      border:1px solid var(--stroke);
    }
    .box h3{margin:8px 0 8px;font-size:18px}
    .box p{color:var(--muted);font-size:15px;line-height:1.6}
    footer{padding:34px 0 50px;color:var(--muted);font-size:13px}
    @media (max-width:960px){
      .hero,.grid3,.grid4{grid-template-columns:1fr 1fr}
      .hero{grid-template-columns:1fr}
      h1{font-size:42px}
    }
    @media (max-width:640px){
      .grid3,.grid4,.stats{grid-template-columns:1fr}
      .panel,.card,.box{padding:18px}
      h1{font-size:34px}
      .section-head h2{font-size:28px}
      p.lead{font-size:18px}
    }
  </style>
</head>
<body>
  <header>
    <div class="wrap head">
      <div class="brand">
        <small>British English • London Style</small>
        <strong>Ai Студия изучения английского языка Дарьи Ершовой</strong>
      </div>
      <nav>
        <a href="#about">О платформе</a>
        <a href="#method">Как это работает</a>
        <a href="#pricing">Тарифы</a>
        <a href="#contact" class="cta">Начать</a>
      </nav>
    </div>
  </header>

  <main class="wrap">
    <section class="hero" id="about">
      <div class="panel">
        <div class="eyebrow">London calling • Speak beautifully</div>
        <h1>Британский английский в современном AI‑формате.</h1>
        <p class="lead">Ai Студия Дарьи Ершовой — это тест уровня, игровые задания, живая практика, онлайн‑уроки и AI‑наставник, который сопровождает ученика по персональному маршруту роста.</p>
        <div class="chips">
          <span class="chip">999 ₽ / месяц</span>
          <span class="chip">Private от 1500 ₽ / час</span>
          <span class="chip">AI memory</span>
        </div>
        <div class="row">
          <a class="btn btn-primary" href="#contact">Пройти тест уровня</a>
          <a class="btn btn-ghost" href="#pricing">Смотреть тарифы</a>
        </div>
      </div>

      <aside class="card">
        <div class="badge">Student journey</div>
        <h2>От теста к привычке учиться каждый день</h2>
        <p class="muted">Платформа мягко переводит пользователя от первого касания к регулярному обучению, premium‑подписке и личным урокам.</p>
        <div class="stats">
          <div class="stat"><span class="muted">Уровень</span><strong>B1</strong></div>
          <div class="stat"><span class="muted">Серия</span><strong>14 дней</strong></div>
          <div class="stat"><span class="muted">Фокус</span><strong>Speaking</strong></div>
          <div class="stat"><span class="muted">След. урок</span><strong>19:00</strong></div>
        </div>
      </aside>
    </section>

    <section id="method">
      <div class="section-head">
        <div>
          <div class="badge">Как это работает</div>
          <h2>Одна система: тест, AI, игра, уроки.</h2>
        </div>
      </div>
      <div class="grid4">
        <article class="box">
          <div class="muted">01</div>
          <h3>Тест уровня</h3>
          <p>Пользователь проходит диагностику и сразу видит свой старт.</p>
        </article>
        <article class="box">
          <div class="muted">02</div>
          <h3>AI‑маршрут</h3>
          <p>Бот сохраняет прогресс и предлагает следующий шаг под уровень ученика.</p>
        </article>
        <article class="box">
          <div class="muted">03</div>
          <h3>Игровой режим</h3>
          <p>Лексика и грамматика подаются через реальные ситуации и быстрый feedback.</p>
        </article>
        <article class="box">
          <div class="muted">04</div>
          <h3>Живые уроки</h3>
          <p>Дарья и команда закрепляют результат и ускоряют рост речи.</p>
        </article>
      </div>
    </section>

    <section id="pricing">
      <div class="section-head">
        <div>
          <div class="badge">Тарифы</div>
          <h2>Вход лёгкий, рост системный.</h2>
        </div>
      </div>
      <div class="grid3">
        <article class="box">
          <h3>Free start</h3>
          <p>Тест, первое знакомство, демонстрационные задания.</p>
        </article>
        <article class="box">
          <h3>Premium — 999 ₽ / мес</h3>
          <p>Основной формат: AI‑сопровождение, регулярные задания и прогресс по маршруту.</p>
        </article>
        <article class="box">
          <h3>Private — от 1500 ₽ / час</h3>
          <p>Персональная работа с Дарьей или преподавателями команды.</p>
        </article>
      </div>
    </section>

    <section id="contact">
      <div class="panel">
        <div class="badge">Start</div>
        <h2 style="font-size:34px;margin-bottom:14px;">Начните с теста и получите персональный маршрут.</h2>
        <p class="lead" style="font-size:18px;">Сайт уже стабильно работает. Следующий шаг — загрузить полноценную финальную версию с локальными изображениями, игровыми экранами и полноценной воронкой записи.</p>
        <div class="row">
          <a class="btn btn-primary" href="#">Start your level test</a>
          <a class="btn btn-ghost" href="#">Онлайн‑урок с Дарьей</a>
        </div>
      </div>
    </section>

    <footer>
      © Ai Студия изучения английского языка Дарьи Ершовой • стабильная версия без внешних фоновых изображений
    </footer>
  </main>
</body>
</html>
EOF
systemctl restart nginx
curl -I http://127.0.0.1 | head -n 5'
bash -lc 'cat >/var/www/darya-english/index.html <<EOF
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Ai Студия изучения английского языка Дарьи Ершовой</title>
  <meta name="description" content="British English, AI-обучение, тест уровня, игровые задания, онлайн-уроки с Дарьей Ершовой и её командой.">
  <style>
    :root{
      --bg:#0b0f17;
      --bg2:#151c29;
      --card:rgba(16,22,34,.84);
      --stroke:rgba(255,255,255,.12);
      --text:#f6efe4;
      --muted:#d5cab9;
      --accent:#ff4f7d;
      --accent2:#7bc4ff;
    }
    *{box-sizing:border-box;margin:0;padding:0}
    body{
      min-height:100vh;
      font-family:Arial,sans-serif;
      color:var(--text);
      background:
        radial-gradient(circle at 15% 20%, rgba(255,79,125,.22), transparent 32%),
        radial-gradient(circle at 80% 70%, rgba(123,196,255,.18), transparent 30%),
        linear-gradient(135deg, var(--bg), var(--bg2) 50%, #1b1020 100%);
    }
    .wrap{width:min(1180px,calc(100% - 24px));margin:0 auto}
    header{
      position:sticky;top:0;z-index:5;
      backdrop-filter:blur(14px);
      background:rgba(8,11,18,.72);
      border-bottom:1px solid rgba(255,255,255,.08);
    }
    .head{
      display:flex;justify-content:space-between;align-items:center;gap:16px;
      padding:16px 0;flex-wrap:wrap;
    }
    .brand strong{display:block;font-size:15px}
    .brand small{display:block;font-size:12px;color:var(--muted);letter-spacing:.14em;text-transform:uppercase}
    nav{display:flex;gap:10px;flex-wrap:wrap}
    nav a{
      color:var(--muted);
      text-decoration:none;
      font-size:14px;
      padding:10px 14px;
      border-radius:999px;
      border:1px solid transparent;
    }
    nav a.cta{
      background:var(--accent);
      color:#fff;
    }
    .hero{
      display:grid;
      grid-template-columns:1.1fr .9fr;
      gap:24px;
      align-items:start;
      padding:48px 0 28px;
    }
    .panel,.card,.box{
      background:var(--card);
      border:1px solid var(--stroke);
      border-radius:28px;
      box-shadow:0 24px 70px rgba(0,0,0,.35);
      backdrop-filter:blur(14px);
    }
    .panel,.card,.box{padding:24px}
    .eyebrow{
      font-size:12px;
      letter-spacing:.16em;
      text-transform:uppercase;
      color:var(--muted);
      margin-bottom:10px;
    }
    h1{
      font-size:54px;
      line-height:1.02;
      margin-bottom:18px;
      max-width:12ch;
    }
    p.lead{
      font-size:20px;
      line-height:1.6;
      color:var(--muted);
      max-width:60ch;
    }
    .row{display:flex;gap:12px;flex-wrap:wrap;margin-top:24px}
    .btn{
      min-height:46px;
      padding:0 20px;
      border-radius:999px;
      display:inline-flex;
      align-items:center;
      justify-content:center;
      text-decoration:none;
      font-size:15px;
      border:none;
      cursor:pointer;
    }
    .btn-primary{background:var(--accent);color:#fff}
    .btn-ghost{border:1px solid var(--stroke);color:#fff;background:transparent}
    .chips{display:flex;flex-wrap:wrap;gap:10px;margin-top:18px}
    .chip{
      padding:9px 14px;
      border-radius:999px;
      background:rgba(255,255,255,.04);
      border:1px solid var(--stroke);
      color:var(--muted);
      font-size:13px;
    }
    .stats{display:grid;grid-template-columns:repeat(2,1fr);gap:12px;margin-top:20px}
    .stat{
      padding:16px;
      border-radius:20px;
      background:rgba(255,255,255,.04);
      border:1px solid var(--stroke);
    }
    .stat strong{display:block;font-size:24px}
    section{padding:18px 0}
    .section-head{display:flex;justify-content:space-between;gap:16px;align-items:end;flex-wrap:wrap;margin-bottom:18px}
    .section-head h2{font-size:34px}
    .badge{
      display:inline-flex;
      padding:8px 12px;
      border-radius:999px;
      border:1px solid var(--stroke);
      color:var(--muted);
      font-size:12px;
      text-transform:uppercase;
      letter-spacing:.12em;
      margin-bottom:10px;
    }
    .grid3,.grid4{display:grid;gap:14px}
    .grid3{grid-template-columns:repeat(3,1fr)}
    .grid4{grid-template-columns:repeat(4,1fr)}
    .box h3{margin:8px 0 8px;font-size:18px}
    .box p{color:var(--muted);font-size:15px;line-height:1.6}
    #quizBox{display:none;margin-top:18px}
    .quiz-option{
      width:100%;
      text-align:left;
      padding:14px 16px;
      border-radius:18px;
      border:1px solid var(--stroke);
      background:rgba(255,255,255,.04);
      color:#fff;
      margin-top:10px;
      cursor:pointer;
    }
    .quiz-option.active{border-color:var(--accent);background:rgba(255,79,125,.14)}
    .quiz-meta{color:var(--muted);font-size:14px;margin-bottom:10px}
    .result{
      margin-top:18px;
      padding:18px;
      border-radius:22px;
      background:rgba(255,255,255,.05);
      border:1px solid var(--stroke);
    }
    footer{padding:34px 0 50px;color:var(--muted);font-size:13px}
    @media (max-width:960px){
      .hero,.grid3,.grid4{grid-template-columns:1fr 1fr}
      .hero{grid-template-columns:1fr}
      h1{font-size:42px}
    }
    @media (max-width:640px){
      .grid3,.grid4,.stats{grid-template-columns:1fr}
      h1{font-size:34px}
      .section-head h2{font-size:28px}
      p.lead{font-size:18px}
    }
  </style>
</head>
<body>
  <header>
    <div class="wrap head">
      <div class="brand">
        <small>British English • London Style</small>
        <strong>Ai Студия изучения английского языка Дарьи Ершовой</strong>
      </div>
      <nav>
        <a href="#about">О платформе</a>
        <a href="#method">Как это работает</a>
        <a href="#pricing">Тарифы</a>
        <a href="#test" class="cta">Тест</a>
      </nav>
    </div>
  </header>

  <main class="wrap">
    <section class="hero" id="about">
      <div class="panel">
        <div class="eyebrow">London calling • Speak beautifully</div>
        <h1>Британский английский в современном AI‑формате.</h1>
        <p class="lead">Ai Студия Дарьи Ершовой — это тест уровня, игровые задания, живая практика, онлайн‑уроки и AI‑наставник, который сопровождает ученика по персональному маршруту роста.</p>
        <div class="chips">
          <span class="chip">999 ₽ / месяц</span>
          <span class="chip">Private от 1500 ₽ / час</span>
          <span class="chip">AI memory</span>
        </div>
        <div class="row">
          <button class="btn btn-primary" id="startQuizBtn">Пройти тест уровня</button>
          <a class="btn btn-ghost" href="#pricing">Смотреть тарифы</a>
        </div>
      </div>

      <aside class="card">
        <div class="badge">Student journey</div>
        <h2 style="font-size:28px;margin-bottom:12px;">От теста к привычке учиться каждый день</h2>
        <p style="color:var(--muted)">Платформа мягко переводит пользователя от первого касания к регулярному обучению, premium‑подписке и личным урокам.</p>
        <div class="stats">
          <div class="stat"><span style="color:var(--muted)">Уровень</span><strong>B1</strong></div>
          <div class="stat"><span style="color:var(--muted)">Серия</span><strong>14 дней</strong></div>
          <div class="stat"><span style="color:var(--muted)">Фокус</span><strong>Speaking</strong></div>
          <div class="stat"><span style="color:var(--muted)">След. урок</span><strong>19:00</strong></div>
        </div>
      </aside>
    </section>

    <section id="test">
      <div class="section-head">
        <div>
          <div class="badge">Тест уровня</div>
          <h2>Узнайте свой уровень English</h2>
        </div>
      </div>

      <div class="panel">
        <p class="lead" style="font-size:18px">Нажмите на кнопку, чтобы начать короткий тест и получить примерный уровень от A2 до C1.</p>
        <div class="row">
          <button class="btn btn-primary" id="startQuizBtn2">Начать тест</button>
        </div>

        <div id="quizBox">
          <div class="quiz-meta" id="quizMeta">Вопрос 1 из 4</div>
          <h3 id="quizQuestion" style="font-size:24px;margin-bottom:10px;"></h3>
          <div id="quizOptions"></div>
          <div class="row">
            <button class="btn btn-primary" id="nextBtn">Далее</button>
            <button class="btn btn-ghost" id="resetBtn">Сначала</button>
          </div>
          <div class="result" id="quizResult" style="display:none;"></div>
        </div>
      </div>
    </section>

    <section id="method">
      <div class="section-head">
        <div>
          <div class="badge">Как это работает</div>
          <h2>Одна система: тест, AI, игра, уроки.</h2>
        </div>
      </div>
      <div class="grid4">
        <article class="box">
          <div style="color:var(--muted)">01</div>
          <h3>Тест уровня</h3>
          <p>Пользователь проходит диагностику и сразу видит свой старт.</p>
        </article>
        <article class="box">
          <div style="color:var(--muted)">02</div>
          <h3>AI‑маршрут</h3>
          <p>Бот сохраняет прогресс и предлагает следующий шаг под уровень ученика.</p>
        </article>
        <article class="box">
          <div style="color:var(--muted)">03</div>
          <h3>Игровой режим</h3>
          <p>Лексика и грамматика подаются через реальные ситуации и быстрый feedback.</p>
        </article>
        <article class="box">
          <div style="color:var(--muted)">04</div>
          <h3>Живые уроки</h3>
          <p>Дарья и команда закрепляют результат и ускоряют рост речи.</p>
        </article>
      </div>
    </section>

    <section id="pricing">
      <div class="section-head">
        <div>
          <div class="badge">Тарифы</div>
          <h2>Вход лёгкий, рост системный.</h2>
        </div>
      </div>
      <div class="grid3">
        <article class="box">
          <h3>Free start</h3>
          <p>Тест, первое знакомство, демонстрационные задания.</p>
        </article>
        <article class="box">
          <h3>Premium — 999 ₽ / мес</h3>
          <p>Основной формат: AI‑сопровождение, регулярные задания и прогресс по маршруту.</p>
        </article>
        <article class="box">
          <h3>Private — от 1500 ₽ / час</h3>
          <p>Персональная работа с Дарьей или преподавателями команды.</p>
        </article>
      </div>
    </section>

    <footer>
      © Ai Студия изучения английского языка Дарьи Ершовой • версия с рабочим тестом
    </footer>
  </main>

  <script>
    const quizData = [
      {
        q: "Choose the correct sentence:",
        options: [
          "I have been living in London for five years.",
          "I am living in London for five years.",
          "I live in London since five years."
        ],
        correct: 0
      },
      {
        q: "Выберите более естественный вариант:",
        options: [
          "Can you tell me where the station is?",
          "Can you tell me where is the station?",
          "Say me where the station is."
        ],
        correct: 0
      },
      {
        q: "Complete the sentence:",
        options: [
          "If I had more time, I would study every day.",
          "If I would have more time, I study every day.",
          "If I will have more time, I would study every day."
        ],
        correct: 0
      },
      {
        q: "Что звучит вежливо по-британски?",
        options: [
          "Give me tea.",
          "I want tea.",
          "Could I have a cup of tea, please?"
        ],
        correct: 2
      }
    ];

    let current = 0;
    let score = 0;
    let selected = null;

    const quizBox = document.getElementById("quizBox");
    const quizMeta = document.getElementById("quizMeta");
    const quizQuestion = document.getElementById("quizQuestion");
    const quizOptions = document.getElementById("quizOptions");
    const quizResult = document.getElementById("quizResult");
    const nextBtn = document.getElementById("nextBtn");
    const resetBtn = document.getElementById("resetBtn");
    const startQuizBtn = document.getElementById("startQuizBtn");
    const startQuizBtn2 = document.getElementById("startQuizBtn2");

    function openQuiz() {
      quizBox.style.display = "block";
      quizResult.style.display = "none";
      document.getElementById("test").scrollIntoView({behavior:"smooth"});
      renderQuestion();
    }

    function renderQuestion() {
      const item = quizData[current];
      quizMeta.textContent = "Вопрос " + (current + 1) + " из " + quizData.length;
      quizQuestion.textContent = item.q;
      quizOptions.innerHTML = "";
      selected = null;

      item.options.forEach((opt, index) => {
        const btn = document.createElement("button");
        btn.className = "quiz-option";
        btn.type = "button";
        btn.textContent = opt;
        btn.addEventListener("click", function() {
          selected = index;
          document.querySelectorAll(".quiz-option").forEach(el => el.classList.remove("active"));
          btn.classList.add("active");
        });
        quizOptions.appendChild(btn);
      });

      nextBtn.textContent = current === quizData.length - 1 ? "Завершить" : "Далее";
    }

    function showResult() {
      let level = "";
      let text = "";

      if (score <= 1) {
        level = "A2";
        text = "У вас базовый уровень. Хорошая точка входа в регулярную практику и Premium-маршрут.";
      } else if (score === 2) {
        level = "B1";
        text = "У вас уверенный средний уровень. Самое время усиливать speaking, vocabulary и confidence.";
      } else if (score === 3) {
        level = "B2";
        text = "У вас сильная база. Можно переходить к сложным темам и красивой живой речи.";
      } else {
        level = "C1";
        text = "Очень хороший уровень. Дальше — тонкая настройка речи, интонации и стиля.";
      }

      quizResult.style.display = "block";
      quizResult.innerHTML = "<strong>Ваш примерный уровень: " + level + "</strong><br><br>" + text;
    }

    nextBtn.addEventListener("click", function() {
      if (selected === null) return;
      if (selected === quizData[current].correct) score++;

      if (current < quizData.length - 1) {
        current++;
        renderQuestion();
      } else {
        showResult();
      }
    });

    resetBtn.addEventListener("click", function() {
      current = 0;
      score = 0;
      selected = null;
      quizResult.style.display = "none";
      renderQuestion();
    });

    startQuizBtn.addEventListener("click", openQuiz);
    startQuizBtn2.addEventListener("click", openQuiz);
  </script>
</body>
</html>
EOF
systemctl restart nginx
curl -I http://127.0.0.1 | head -n 5'
sudo mkdir -p /var/www/london-ai && sudo cp english-language-studio-london-ai-live.html /var/www/london-ai/index.html && sudo mkdir -p /var/www/london-ai/assets && sudo cp -r assets/* /var/www/london-ai/assets/ && sudo chown -R www-www-data /var/www/london-ai && sudo find /var/www/london-ai -type d -exec chmod 755 {} \; && sudo find /var/www/london-ai -type f -exec chmod 644 {} \; && sudo nginx -t && sudo systemctl reload nginx
sudo bash -lc 'cat >/etc/nginx/sites-available/london-ai.conf <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name _;
    root /var/www/london-ai;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF
ln -sf /etc/nginx/sites-available/london-ai.conf /etc/nginx/sites-enabled/london-ai.conf
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx'
cd /путь/к/папке/сайта && python3 -m http.server 8000
sudo apt update && sudo apt install -y rsync openssh-server && sudo mkdir -p /var/www/mysite && sudo chown -R $USER:$USER /var/www/mysite
REMOTE_PATH="/var/www/mysite"
REMOTE_RELOAD_CMD="sudo systemctl reload nginx"
REMOTE_PATH="/var/www/mysite"
REMOTE_RELOAD_CMD="sudo systemctl reload nginx"
pm2 reload your-app-name
sudo apt update && sudo apt install -y nginx rsync openssh-server && sudo mkdir -p /var/www/mysite && echo '<h1>Site works</h1>' | sudo tee /var/www/mysite/index.html >/dev/null && sudo chown -R www-www-data /var/www/mysite && sudo systemctl enable --now nginx && sudo systemctl reload nginx
sudo apt update && sudo apt install -y nginx rsync openssh-server && echo '<h1>Site works</h1>' | sudo tee /var/www/html/index.html >/dev/null && sudo chown -R www-data:www-data /var/www/html && sudo systemctl enable --now nginx && sudo systemctl restart nginx
REMOTE_PATH="/var/www/html"
REMOTE_RELOAD_CMD="sudo systemctl reload nginx"
npm run build && rsync -azvh --delete ./dist/ USER@IP_VPS:/var/www/html/ && ssh USER@IP_VPS "sudo systemctl reload nginx"
USER
IP_VPS
npm run build && rsync -azvh --delete -e "ssh -i ~/.ssh/id_rsa" ./dist/ USER@IP_VPS:/var/www/html/ && ssh -i ~/.ssh/id_rsa USER@IP_VPS "sudo systemctl reload nginx"
Ctrl + F5
cd /var/www/site && git pull && npm install && npm run build && sudo rm -rf /var/www/html/* && sudo cp -r dist/* /var/www/html/ && sudo systemctl reload nginx
cd /var/www && git clone URL_ВАШЕГО_REPO site && cd site && npm install && npm run build && sudo rm -rf /var/www/html/* && sudo cp -r dist/* /var/www/html/ && sudo systemctl reload nginx
sudo bash -lc 'set -e; WEB=/var/www/html; mkdir -p "$WEB"; HTML=$(find /root /home /var/www -maxdepth 5 -type f \\( -name "english-language-studio-london-ai-live.html" -o -name "index.html" \\) 2>/dev/null | grep -v "/var/www/html/index.html" | head -n 1); if [ -z "$HTML" ]; then echo "ОШИБКА: файл сайта не найден на VPS. Нужно сначала загрузить index.html и assets на сервер."; exit 1; fi; SRC=$(dirname "$HTML"); echo "Найден сайт: $HTML"; rm -rf "$WEB"/*; cp "$HTML" "$WEB/index.html"; if [ -d "$SRC/assets" ]; then cp -a "$SRC/assets" "$WEB/assets"; fi; chown -R www-www-data "$WEB"; find "$WEB" -type d -exec chmod 755 {} \;; find "$WEB" -type f -exec chmod 644 {} \;; rm -f /etc/nginx/sites-enabled/london-ai.conf; cat >/etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    root /var/www/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default; nginx -t; systemctl restart nginx; echo "ГОТОВО: сайт обновлён. Открой http://186.246.31.45/?v=$(date +%s)"'
sudo bash -lc 'set -e; APP=/var/www/DariaeAi-; WEB=/var/www/html; apt update; apt install -y git nginx nodejs npm; rm -rf "$APP"; git clone https://github.com/AItestsibiria/DariaeAi-.git "$APP"; cd "$APP"; if [ -f package.json ]; then npm install; npm run build || true; fi; rm -rf "$WEB"/*; if [ -d dist ]; then cp -a dist/. "$WEB"/; else cp -a . "$WEB"/; fi; chown -R www-www-data "$WEB"; find "$WEB" -type d -exec chmod 755 {} \;; find "$WEB" -type f -exec chmod 644 {} \;; rm -f /etc/nginx/sites-enabled/london-ai.conf; cat >/etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    root /var/www/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default; nginx -t; systemctl enable --now nginx; systemctl restart nginx; echo "ГОТОВО: открой http://186.246.31.45/?v=$(date +%s)"'
ssh-keygen -t ed25519 -C "vps-dariaeai" -f ~/.ssh/dariaeai_deploy -N "" && cat ~/.ssh/dariaeai_deploy.pub
cd /var/www && rm -rf DariaeAi- && GIT_SSH_COMMAND='ssh -i ~/.ssh/dariaeai_deploy -o StrictHostKeyChecking=accept-new' git clone git@github.com:AItestsibiria/DariaeAi-.git DariaeAi- && cd DariaeAi- && apt install -y nodejs npm && npm install && npm run build && rm -rf /var/www/html/* && cp -a dist/. /var/www/html/ && chown -R www-www-data /var/www/html && systemctl restart nginx
http://dariaeai.ru
echo "=== NGINX ===" && systemctl is-active nginx && nginx -t && echo "=== SITE FILES ===" && ls -lah /var/www/html | head -30 && test -f /var/www/html/index.html && echo "index.html OK" || echo "index.html НЕТ" && echo "=== LOCAL HTTP ===" && curl -I http://127.0.0.1 | head -5 && echo "=== PUBLIC HTTP ===" && curl -I http://186.246.31.45 | head -5 && echo "=== DOMAIN DNS ===" && getent hosts dariaeai.ru || echo "DNS dariaeai.ru ещё не смотрит на VPS" && echo "=== GITHUB SSH ===" && ssh -T -i ~/.ssh/dariaeai_deploy -o StrictHostKeyChecking=accept-new git@github.com || true && echo "=== DONE === Если выше есть HTTP/1.1 200 OK или 304, nginx active и index.html OK — всё заебись."
echo "=== NGINX ROOT ===" && nginx -T 2>/dev/null | grep -E "server_name|root " | head -30 && echo "=== HTML FILE ===" && ls -lah /var/www/html && echo "=== INDEX PREVIEW ===" && sed -n "1,40p" /var/www/html/index.html
cd /var/www && rm -rf DariaeAi- && GIT_SSH_COMMAND='ssh -i ~/.ssh/dariaeai_deploy -o StrictHostKeyChecking=accept-new' git clone git@github.com:AItestsibiria/DariaeAi-.git DariaeAi- && cd DariaeAi- && apt update && apt install -y nodejs npm && npm install && npm run build && rm -rf /var/www/html/* && cp -a dist/. /var/www/html/ && chown -R www-www-data /var/www/html && systemctl restart nginx && echo "ГОТОВО: открой http://186.246.31.45/?v=$(date +%s)"
ssh -T -i ~/.ssh/dariaeai_deploy -o StrictHostKeyChecking=accept-new git@github.com
cat ~/.ssh/dariaeai_deploy.pub
dssh -T -i ~/.ssh/dariaeai_deploy -o StrictHostKeyChecking=accept-new git@github.com
cd /var/www && rm -rf DariaeAi- && GIT_SSH_COMMAND='ssh -i ~/.ssh/dariaeai_deploy -o StrictHostKeyChecking=accept-new' git clone git@github.com:AItestsibiria/DariaeAi-.git DariaeAi- && cd DariaeAi- && npm install && npm run build && rm -rf /var/www/html/* && cp -a dist/. /var/www/html/ && chown -R www-www-data /var/www/html && systemctl restart nginx
cat ~/.ssh/dariaeai_deploy.pub
ssh -T -i ~/.ssh/dariaeai_deploy -o StrictHostKeyChecking=accept-new git@github.com
