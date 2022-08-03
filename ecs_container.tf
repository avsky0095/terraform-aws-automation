
resource "aws_ecs_cluster" "ecs_cluster_test" {
  name = "cluster-test-ecs"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}