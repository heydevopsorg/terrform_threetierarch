resource "aws_nat_gateway" "gw" {
  count         = length(aws_subnet.public_subnets)
  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  depends_on    = [aws_internet_gateway.gw]
  tags = {
    "Name" = "nat_gw_${count.index + 1}"
  }
}
