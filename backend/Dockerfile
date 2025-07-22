# Dockerfile para KM$ Backend - Dart/Shelf
FROM dart:stable AS build

# Copiar arquivos de dependência
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copiar código fonte
COPY . .
RUN dart compile exe bin/server.dart -o bin/server

# Imagem de produção
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Expor porta
EXPOSE 3000

# Executar servidor
ENTRYPOINT ["/app/bin/server"]