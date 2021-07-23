output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_public_ids" {
  value = aws_subnet.public.*.id
}
