locals {
  final_tags = merge(
    var.tags,
    {
      ManagedBy = "terraform"
    }
  )
}
