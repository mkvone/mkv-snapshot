#other cosmos chains (like odin,emoney, etc)
cd $HOME
git clone https://github.com/binaryholdings/cosmprund
cd cosmprund
git reset --hard d3bf3d8
sudo docker build -t cosmprund .

#osmosis 
cd $HOME 
git clone https://github.com/czarcas7ic/cosmprund osmosis_cosmprund
cd osmosis_cosmprund
sudo docker build -t osmosis_cosmprund .
# git clone https://github.com/osmosis-labs/cosmprund osmosis_cosmprund_test


# cd $HOME 
# git clone https://github.com/osmosis-labs/cosmprund osmosis_cosmprund_test
# cd osmosis_cosmprund_test
# sudo docker build -t osmosis_cosmprund_test .
# sudo docker run -v ~/test:/.osmosisd/data osmosis_cosmprund_test prune .osmosisd/data

# sudo docker stop cosmprund || true
# sudo docker rm cosmprund || true
# sudo docker run --name cosmprund
# sudo docker run cosmprund prune ~/.kid/data
# sudo docker run -v ~/.kid/data:/.kid/data cosmprund prune .kid/data
# sudo docker run -v ~/.osmosisd/data:/.osmosisd/data osmosis_cosmprund prune .osmosisd/data
