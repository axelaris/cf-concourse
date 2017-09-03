path "secret/*" {
  policy = "read"
  capabilities =  ["read", "list", "update", "create"]
}
