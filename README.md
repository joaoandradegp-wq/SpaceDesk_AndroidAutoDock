<h1 align="center">🛰️ SpaceDesk Android AutoDock</h1>

<p align="center">
  O SpaceDesk Android AutoDock é um script para tablets Android antigos que transforma o tablet em um relógio de mesa que vira segundo monitor automaticamente.
  Quando o PC liga, o tablet abre o spacedesk e o traz para a frente. Quando o PC desliga, ele volta para o app de relógio.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Status-Funcionando-brightgreen">
  <img src="https://img.shields.io/badge/Plataforma-Android-3DDC84?logo=android">
  <img src="https://img.shields.io/badge/Execução-Termux-red?logo=gnubash">
  <img src="https://img.shields.io/badge/Fonte-spacedesk-orange">
  <img src="https://img.shields.io/badge/Idioma-PT--BR-purple">
  <img src="https://img.shields.io/badge/Root-Não%20necessário-blue">
</p>

---

## ✨ Funcionalidades

<table>

<tr>
<td width="50%" valign="top">

#### 🖥️ DETECÇÃO DO PC

<ul>
<li>Detecta quando o PC liga ou desliga pela rede</li>
<li>Usa somente ping, sem conectar na porta do spacedesk</li>
<li>Não dispara a janela "Connection Notification" no Windows</li>
<li>Tolera falhas isoladas antes de considerar o PC desligado</li>
<li>Funciona com o IP fixo do PC na rede local</li>
</ul><br>

</td>
<td width="50%" valign="top">

#### 📱 CONTROLE DOS APPS

<ul>
<li>Abre o spacedesk e o traz para a frente quando o PC liga</li>
<li>Volta para o app de relógio quando o PC desliga</li>
<li>Abre os apps pela atividade exata, compatível com Androids antigos</li>
<li>Não precisa de root</li>
<li>Mostra no terminal cada vez que troca de app</li>
</ul><br>

</td>
</tr>

<tr>
<td width="50%" valign="top">

#### ⚙️ CONFIGURAÇÃO

<ul>
<li>Todas as opções ficam nas primeiras linhas do script</li>
<li>Define o IP do PC, os apps e o intervalo de verificação</li>
<li>Ajusta quantas falhas seguidas indicam PC desligado</li>
<li>Funciona com qualquer app de relógio</li>
</ul><br>

</td>
<td width="50%" valign="top">

#### 🔄 INICIALIZAÇÃO AUTOMÁTICA

<ul>
<li>Sobe sozinho quando o tablet liga, via Termux:Boot</li>
<li>Mantém o tablet acordado com o wake lock do Termux</li>
<li>Roda em segundo plano, sem precisar abrir o Termux</li>
<li>Pode ser parado com um único comando</li>
</ul><br>

</td>
</tr>

</table>

---

## 🚀 Como utilizar

### 1. Instalar o Termux

O Termux da Play Store está desatualizado. Instale pelo **F-Droid**, no navegador do tablet:

<ol>
<li>Acesse <a href="https://f-droid.org/packages/com.termux/">f-droid.org/packages/com.termux</a> e toque em <code>Download APK</code>.</li>
<li>Instale o arquivo baixado (permita a instalação de fontes desconhecidas, se o Android pedir).</li>
<li>Repita o processo para o <a href="https://f-droid.org/packages/com.termux.boot/">Termux:Boot</a>.</li>
<li>Abra o <b>Termux:Boot</b> uma vez, senão ele não se registra para iniciar com o sistema.</li>
</ol>

> Instale o Termux e o Termux:Boot da **mesma fonte** (F-Droid). Misturar com Play Store ou GitHub causa conflito de assinatura.

### 2. Preparar o PC

<ol>
<li><b>Fixe o IP do PC</b> com uma reserva de DHCP no painel do roteador.</li>
<li><b>Descubra o IP</b> do PC: abra o Prompt de Comando e rode <code>ipconfig</code>.</li>
<li><b>Libere o ping</b> no Windows (PowerShell como administrador):</li>
</ol>

```
netsh advfirewall firewall add rule name="Permitir ping" protocol=icmpv4:8,any dir=in action=allow
```

Instale também o driver do [spacedesk](https://spacedesk.net/) no PC e o app no tablet.

### 3. Copiar o script para o Termux

Envie o `monitor.sh` para a pasta **Download** do tablet (por AnyDesk, cabo ou nuvem). No Termux:

```bash
termux-setup-storage
cp ~/storage/downloads/monitor.sh ~/monitor.sh
sed -i 's/\r$//' ~/monitor.sh
chmod +x ~/monitor.sh
```

Toque em **Permitir** quando o Android pedir acesso ao armazenamento. O `sed` remove os fins de linha do Windows, que causam o erro `bad interpreter`.

### 4. Configurar o IP do PC

Troque `192.168.100.71` pelo IP do seu PC:

```bash
sed -i 's/^PC_NOME=.*/PC_NOME="192.168.100.71"/' ~/monitor.sh
grep -n "PC_NOME=" ~/monitor.sh
```

Teste se o tablet enxerga o PC:

```bash
ping -c 1 192.168.100.71
```

> O Android não resolve nomes de rede do Windows (como `Phobos`). Use sempre o IP.

### 5. Conferir os apps

O script já vem com as atividades que funcionaram nos testes:

<ul>
<li><b>spacedesk:</b> <code>ph.spacedesk.beta/ph.spacedesk.httpwww.spacedesk.SAActivityConnect</code></li>
<li><b>Relógio Pro:</b> <code>com.cama.app.huge80sclockPro/com.cama.app.huge80sclockPro.MainActivity</code></li>
</ul>

Teste cada um à mão. O app deve abrir na frente:

```bash
PATH=/system/bin:$PATH LD_LIBRARY_PATH= /system/bin/am start --user 0 -n ph.spacedesk.beta/ph.spacedesk.httpwww.spacedesk.SAActivityConnect
```

Se usar outro app de relógio ou outra versão do spacedesk, veja [Como descobrir a atividade de um app](#-como-descobrir-a-atividade-de-um-app).

### 6. Testar o script

```bash
~/monitor.sh
```

<ul>
<li><b>Ligue o PC:</b> o terminal mostra <code>PC online, abrindo spacedesk</code> e o spacedesk abre na frente.</li>
<li><b>Desligue o PC:</b> em cerca de 15 segundos o terminal mostra <code>PC offline, voltando ao relogio</code> e o relógio volta.</li>
</ul>

Para parar o teste: `Ctrl+C`.

### 7. Ajustar as permissões do Android

Em **Configurações, Apps, Termux**:

<ul>
<li>ative <b>Exibir sobre outros apps</b> (sem isso o Android pode bloquear a abertura dos apps em segundo plano);</li>
<li>deixe a <b>Bateria sem restrições</b>.</li>
</ul>

Faça o mesmo para o **Termux:Boot**.

### 8. Iniciar junto com o tablet

```bash
mkdir -p ~/.termux/boot
cp boot/start.sh ~/.termux/boot/start.sh
chmod +x ~/.termux/boot/start.sh
```

Reinicie o tablet, espere 1 a 2 minutos e confira com:

```bash
pgrep -fa monitor.sh
```

Se aparecer uma linha, o script subiu sozinho.

---

## 📄 Exemplo de execução

```text
21:36:18 PC online, abrindo spacedesk
21:42:07 PC offline, voltando ao relogio
```

*Exemplo ilustrativo. O terminal só mostra mensagens quando o script troca de app.*

---

## 🔎 Como descobrir a atividade de um app

Em Androids antigos, abrir um app só pelo nome do pacote falha com `unable to resolve Intent`. É preciso abrir pela atividade exata.

<ol>
<li>Confirme o caminho do app: <code>PATH=/system/bin:$PATH LD_LIBRARY_PATH= /system/bin/pm path NOME.DO.PACOTE</code></li>
<li>Instale o <code>unzip</code> no Termux: <code>pkg install unzip</code></li>
<li>Liste as atividades do app (ajuste a pasta conforme o caminho do passo 1):</li>
</ol>

```bash
unzip -p /data/app/NOME.DO.PACOTE-1/base.apk AndroidManifest.xml | tr -d '\0' | grep -a -o 'PREFIXO[A-Za-z0-9_.$]*' | sort -u
```

A tela de entrada costuma ter no nome `Main`, `Splash` ou `Connect`. Teste:

```bash
PATH=/system/bin:$PATH LD_LIBRARY_PATH= /system/bin/am start --user 0 -n NOME.DO.PACOTE/ATIVIDADE
```

Quando o app abrir, coloque o valor `pacote/atividade` em `SPACEDESK_ATIV` ou `RELOGIO_ATIV` no `monitor.sh`.

---

## 📁 Arquivos

| Arquivo | Descrição |
|---|---|
| `monitor.sh` | Script principal, copiado para `~/monitor.sh` no Termux |
| `boot/start.sh` | Inicializador, copiado para `~/.termux/boot/start.sh` |

---

## 🛠️ Tecnologias

<ul>
<li>Shell Script (Bash)</li>
<li>Termux e Termux:Boot</li>
<li>Activity Manager do Android (<code>am</code>)</li>
<li>spacedesk</li>
<li>ICMP (ping)</li>
</ul>

---

## 🎯 Casos de uso

<ul>
<li>Reaproveitar um tablet antigo como relógio de mesa</li>
<li>Ter um segundo monitor que só aparece quando o PC está ligado</li>
<li>Painéis de monitoramento ou dashboards ao lado do PC</li>
<li>Qualquer troca automática de app no Android conforme o estado de outro dispositivo na rede</li>
</ul>

---

## ⚠️ Observações

<ul>
<li>Testado em um tablet Android antigo, sem root. Outras versões podem exigir ajustes.</li>
<li>O PC precisa ter IP fixo e responder a ping.</li>
<li>O script detecta o PC ligado, mas não garante que o servidor do spacedesk já esteja pronto. Se o app abrir antes da hora, ele tenta conectar de novo.</li>
<li>Se o PC apenas suspender e deixar de responder ao ping, o tablet volta para o relógio.</li>
<li>Os nomes de pacote e atividade podem mudar com atualizações dos apps.</li>
</ul>

---

## 🧯 Problemas conhecidos

| Erro | Causa | Solução |
|---|---|---|
| `unknown host` | Android não resolve o nome do PC | Usar o IP |
| `app_process: not found` | Termux remove `/system/bin` do PATH | `PATH=/system/bin:$PATH` |
| `asks to run as user -2` | `am` sem usuário definido | `--user 0` |
| `unable to resolve Intent` | App sem LAUNCHER padrão | Abrir pela atividade com `-n` |
| `Transaction failed on small parcel` | Lista de pacotes grande demais | Usar `pm path` por pacote |
| `bad interpreter` | Fim de linha do Windows (CRLF) | `sed -i 's/\r$//' ~/monitor.sh` |
| Janela piscando no PC | Teste na porta do spacedesk | Detectar só por ping |

---

## 🗑️ Parar e remover

```bash
pkill -f monitor.sh
rm ~/.termux/boot/start.sh
termux-wake-unlock
```

---

<p align="center">
  Desenvolvido para dar uma segunda vida a tablets antigos. 🛰️
</p>
