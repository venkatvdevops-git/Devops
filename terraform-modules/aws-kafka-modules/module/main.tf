module "msk_cluster" {
  source       = "../modules/msk"
  cluster_name = "orders-pipeline-prod"
  vpc_id       = "vpc-12345678"
  subnet_ids   = ["subnet-abc1", "subnet-abc2", "subnet-abc3"]
  client_sg_id = "sg-09876543" # Your Jenkins/Runner SG
}