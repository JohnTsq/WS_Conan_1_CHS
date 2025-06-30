# 构建汉化
> [!IMPORTANT]
> 本项目基于具有如下校验值的 ROM ，构建时请确保所用 ROM 与下述信息一致：
> <table>
>  <tr><th>CRC32</th><th>92fbf7fb</th></tr>
>  <tr><th>MD5</th><th>98e88544d8b7df359e37bf2c17dd0641</th></tr>
>  <tr><th>SHA-1</th><th>8f3f97be31f3bd0e6922ab7795aa6f04bc5cfe2a</th></tr>
> </table>

> [!TIP]
> 部分模拟器支持“软补丁”，只需将补丁文件与 ROM 文件置于同一目录，并确保两者文件名（不含扩展名）一致，即可自动加载补丁。

<!-- 以下两种构建方式，任选其一:

<details><summary><b>补丁构建</b></summary>

1. 从 Releases 下载 bps 格式的补丁文件。<sup>[1]</sup>
2. 准备符合上述校验值的 ROM 文件。
3. 使用支持 bps 格式的补丁工具，将补丁应用于 ROM ，生成汉化后的 ROM 文件。

[1]: 若无法从 Releases 下载，请尝试前往 [ROMHACK.ING](https://romhack.ing/database/content/entry/FNwEEoLASc61cMYmbs9ySA/cardcaptor-sakura-sakura-to-fushigi-na-clow-card-chinese) 下载。

</details> -->

<details><summary><b>armips 构建</b></summary>

1. 克隆本仓库至本地，或下载仓库代码 ZIP 并解压。
2. 将符合校验值的 ROM 文件重命名为 `baserom.ws`，并放置于项目根目录（与 `main.asm` 同级）。
3. 运行 `build.bat`，将在根目录生成汉化后的 ROM 文件 `patched.ws`。

