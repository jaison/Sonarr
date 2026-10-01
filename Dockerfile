# Sonarr v5 - imagem executável para Docker/Easypanel
# Builda o backend .NET e a interface web, depois monta uma imagem de runtime.

FROM node:24.19.0-bookworm-slim AS frontend
WORKDIR /src

RUN corepack enable && corepack prepare yarn@1.22.22 --activate

COPY . .
RUN yarn install --frozen-lockfile \
    && yarn build


FROM mcr.microsoft.com/dotnet/sdk:10.0.401 AS backend
WORKDIR /src

ARG SONARR_VERSION=5.0.0.0
ARG SONARR_BRANCH=v5-develop

COPY . .

# Mantém os mesmos parâmetros de compilação usados pelo workflow oficial do projeto.
RUN dotnet msbuild -restore src/Sonarr.sln \
    -p:SelfContained=true \
    -p:Configuration=Release \
    -p:Platform=Posix \
    -p:RuntimeIdentifiers=linux-arm64 \
    -p:EnableWindowsTargeting=true \
    -p:AssemblyVersion=${SONARR_VERSION} \
    -p:AssemblyConfiguration=${SONARR_BRANCH} \
    -t:PublishAllRids

# Reúne o executável principal e o updater conforme o empacotamento do projeto.
RUN mkdir -p /publish/Sonarr.Update \
    && cp -a _output/net10.0/linux-arm64/publish/. /publish/ \
    && cp -a _output/Sonarr.Update/net10.0/linux-arm64/publish/. /publish/Sonarr.Update/ \
    && cp LICENSE.md /publish/ \
    && cp /publish/Sonarr.Mono.* /publish/Sonarr.Update/ \
    && cp /publish/Openur.Mono.Unix.* /publish/Sonarr.Update/ \
    && cp /publish/libMono.Unix.* /publish/Sonarr.Update/


FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
ENV ASPNETCORE_URLS=http://0.0.0.0:8989 \
    TZ=America/Sao_Paulo \
    HOME=/config

WORKDIR /app

# MediaInfo é utilizado na análise de arquivos de mídia.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        mediainfo \
        sqlite3 \
        tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /config /tv /downloads

COPY --from=backend /publish/ ./
COPY --from=frontend /src/_output/UI ./UI

# Os executáveis são marcados como executáveis, como no empacotamento do projeto.
RUN find /app -type f \( -name "Sonarr" -o -name "Sonarr.Update" -o -name "ffprobe" \) \
    -exec chmod 755 {} +

EXPOSE 8989
VOLUME ["/config", "/tv", "/downloads"]

ENTRYPOINT ["/app/Sonarr", "-nobrowser", "-data=/config"]
