ITERATION=1.0
REVIEW_URL=./reviews/reviews-wlpcfg
USER_ID=local

.PHONY: details ratings page

build: reviews-v1 reviews-v2 reviews-v3 ratings page details

reviews-v1: 
	docker build -t $(USER_ID)/reviews-v1:$(ITERATION) $(REVIEW_URL)

reviews-v2: 
	docker build -t $(USER_ID)/reviews-v2:$(ITERATION) --build-arg service_version=v2 --build-arg enable_ratings=true --build-arg star_color=black $(REVIEW_URL)

reviews-v3: 
	docker build -t $(USER_ID)/reviews-v3:$(ITERATION) --build-arg service_version=v3 --build-arg enable_ratings=true --build-arg star_color=red $(REVIEW_URL)

ratings:  
	docker build -t $(USER_ID)/ratings:$(ITERATION) ./ratings

page: 
	docker build -t $(USER_ID)/productpage:$(ITERATION) ./productpage

details: 
	docker build -t $(USER_ID)/details:$(ITERATION) ./details

run: 
	docker-compose up -d
	
commit: build 
	docker push $(USER_ID)/reviews-v1:$(ITERATION)
	docker push $(USER_ID)/reviews-v2:$(ITERATION)
	docker push $(USER_ID)/reviews-v3:$(ITERATION)
	docker push $(USER_ID)/ratings:$(ITERATION)
	docker push $(USER_ID)/details:$(ITERATION)
	docker push $(USER_ID)/productpage:$(ITERATION)
	
login:
	@echo -n "Please input Dockerhub "
	@docker login -u $(USER_ID)

push: login commit
