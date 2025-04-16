# traders_guild_main_build





COMMANDS

    Argocd
        - kubectl port-forward svc/argocd-server -n argocd 8080:443 -- portfrward localhost
        - kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d -- get password
        - argocd repo add https://github.com/your-username/your-repo.git \
  --username your-username \
  --password your-token-or-password -- add repo to argocd
        - argocd login localhost:8080 \
  --username admin \
  --password <your-password> -- login to argocd


      FASTAPI
      - build new image -  docker build -t ghcr.io/alhennessey92/fastapi-test:latest .
      - push new image




