# railway-xray-tcp

Railway 纯 Xray / VLESS TCP 项目模板。

目标是减少云桌面、WebSocket、TLS、CDN 等额外开销，优先测试 Railway TCP Proxy 的真实速度。

## 文件说明

- `Dockerfile`：使用 Xray 官方镜像构建服务。
- `config.template.json`：Xray 配置模板。
- `entrypoint.sh`：启动时读取环境变量并生成最终配置。
- `railway.json`：告诉 Railway 使用 Dockerfile 构建。
- `.env.example`：本地环境变量示例。
- `docker-compose.yml`：本地测试用。
- `client-template.txt`：客户端填写模板。

## 一、生成 UUID

Windows PowerShell：

```powershell
[guid]::NewGuid()
```

macOS / Linux：

```bash
uuidgen
```

## 二、部署到 Railway

1. 把本项目上传到 GitHub。
2. Railway 新建 Project。
3. 选择 Deploy from GitHub repo。
4. 选择这个仓库。
5. 部署后进入 Variables，添加：

```text
VLESS_UUID=你的UUID
XRAY_PORT=8080
```

`XRAY_PORT` 可以不填，默认就是 `8080`。

## 三、开启 TCP Proxy

进入 Railway 服务：

```text
Service → Settings → Networking → TCP Proxy
```

Target Port / Internal Port 填：

```text
8080
```

Railway 会生成类似：

```text
xxxxx.proxy.rlwy.net:12345
```

记住：客户端端口要填 Railway 生成的公网端口，例如 `12345`，不是 `8080`。

## 四、客户端配置

```text
协议：VLESS
地址：xxxxx.proxy.rlwy.net
端口：Railway TCP Proxy 生成的公网端口
UUID：你的 VLESS_UUID
加密：none
传输协议：TCP
TLS：关闭
SNI：留空
Mux：先关闭
UDP：先关闭
```

## 五、测速建议

不要只看一个测速站。建议分别测：

```text
speed.cloudflare.com
YouTube 实际缓冲
Speedtest 多线程
GitHub Release 下载速度
```

如果仍然低于 15–30 Mbps，优先换 Railway 区域测试：

```text
Singapore → US West → US East → EU West
```

如果所有区域都慢，大概率是你本地运营商到 Railway 的线路问题，不是配置问题。

## 六、注意事项

- 不要和 Ubuntu 云桌面放在同一个 Railway 服务里。
- 不要套 Cloudflare 橙色云朵。
- 不要用这个节点登录 Google 账号恢复、安全验证、银行等敏感账号。
- 先用 TCP 裸配置测速，确认速度后再考虑 TLS/gRPC/WS。
