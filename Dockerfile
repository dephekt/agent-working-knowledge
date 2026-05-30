# Two-stage build: render the static MkDocs site with the pinned mkdocs-material
# builder image, then serve it with nginx. Keep the builder version in sync with
# requirements.txt; the ci-templates workflow reads that version off the build
# stage below to form the published tag suffix (-mkdocs<version>).
# NOTE: do not repeat the builder image reference in comments — the workflow
# greps the first matching line, so an earlier mention would mis-parse the tag.
FROM squidfunk/mkdocs-material:9.5.49 AS builder
WORKDIR /docs
COPY . .
RUN mkdocs build

FROM nginx:1.27-alpine
COPY --from=builder /docs/site /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
