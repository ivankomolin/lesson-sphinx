.PHONY: *

index:
	docker run --rm --net=host \
		-v ${PWD}/data:/app/data \
		-v ${PWD}/etc/sphinx.conf:/app/etc/sphinx.conf \
		ivankomolin/sphinxsearch indexer --all --config /app/etc/sphinx.conf

start:
	docker run --rm --detach --net=host --name=searchd \
		-p 9306:9306 \
		-v ${PWD}/data:/app/data \
		-v ${PWD}/etc/sphinx.conf:/app/etc/sphinx.conf \
		ivankomolin/sphinxsearch

rotate:
	docker exec -it searchd indexer --rotate --all --config /app/etc/sphinx.conf

client:
	docker exec -it searchd mysql -h127.0.0.1 -P9306

stop:
	docker stop searchd