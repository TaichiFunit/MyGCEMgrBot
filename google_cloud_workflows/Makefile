deploy:
	set -a && . ../.env && set +a && gcloud workflows deploy start-$${INSTANCE_ID} --source=start.yaml \
		--set-env-vars ZONE=$${ZONE},INSTANCE_NAME=$${INSTANCE_ID} \
		--location=$${LOCATION}
	set -a && . ../.env && set +a && gcloud workflows deploy stop-$${INSTANCE_ID} --source=stop.yaml \
		--set-env-vars ZONE=$${ZONE},INSTANCE_NAME=$${INSTANCE_ID} \
		--location=$${LOCATION}
