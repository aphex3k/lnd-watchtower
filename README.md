# ⚡️ Lightning Watchtower

Run a Lightning node watchtower in docker.

The following instructions assume your node is already [configured as watchtower client](https://www.lightningnode.info/advanced-tools/watchtower#set-up-the-node-to-be-monitored-the-watchtower-client).

## 🚀 Getting started

Step 1 is to start the watchtower after downloading it.

```sh
git clone https://github.com/aphex3k/lnd-watchtower.git
cd lnd-watchtower
docker-compose up -d
```

## 🛠 Client Configuration

Step 2 is to read the watchtowers connection information

```sh
docker exec -it watchtower lncli tower info
```

Step 3 is to add the information retrieved in the above step to your nodes configuration

```sh
lncli wtclient add "<pubkey>@<host>:<port>"
```

## Check Sessions

Now we can check the nodes list of towers

```sh
lncli wtclient towers
```
