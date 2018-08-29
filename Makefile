docker/run: docker/stop

	docker run 	-v ~/.ssh/id_rsa.pub:/home/foo/.ssh/keys/id_rsa.pub:ro \
				--name sftp							\
    			-p 2222:22 -d atmoz/sftp 			\
    			foo:pass:::upload

docker/stop:

	docker rm -f sftp | true