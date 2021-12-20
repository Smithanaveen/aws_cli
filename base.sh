#CIDR Variables
vpccidr="10.0.0.0/16"
subcidr="10.0.0.0/24"
ami="ami-0b1e2eeb33ce3d66f"

#Create VPC, Subnet, Routetable, associate Route table with subnet - masterVpc

###create VPC
k8svpc=$(aws ec2 create-vpc --cidr-block $vpccidr | jq '.Vpc.VpcId' | tr -d '"')
#assign tags
aws ec2 create-tags --resources $k8svpc --tags Key=Name,Value=k8svpc

#create subnet
sub=$(aws ec2 create-subnet --vpc-id $mastervpc --cidr-block $subcidr --availability-zone us-west-2a | jq '.Subnet.SubnetId' | tr -d '"')
aws ec2 create-tags --resources $msub --tags Key=Name,Value=sub

#Create route table
subrtb=$(aws ec2 create-route-table --vpc-id $mastervpc | jq '.RouteTable.RouteTableId' | tr -d '"')
aws ec2 create-tags --resources $msubrtb --tags Key=Name,Value=subrtb
aws ec2 associate-route-table --route-table-id $subrtb --subnet-id $sub

#Create IGW
aws ec2 create-internet-gateway
#capture: igwid=""
aws ec2 attach-internet-gateway --internet-gateway-id $igwid --vpc-id $k8svpc
#create route entry
aws ec2 create-route --route-table-id $subrtb --destination-cidr-block 0.0.0.0/0 --gateway-id $igwid
#one time activity:
aws ec2 create-key-pair --key-name demokp --query 'KeyMaterial' --output text > MyKeyPair.pem

#Create SG
aws ec2 create-security-group --group-name sshsg --vpc-id $k8svpc --description sshfork8s
#capture: sshsgid=""
aws ec2 authorize-security-group-ingress --group-id $sshsgid --protocol tcp --port 22 --cidr 0.0.0.0/0

#create eip:
aws ec2 allocate-address
#capture allocid
#tag the resource:
aws ec2 create-tags --resources $allocid --tags Key=k8s,Value=SSH


#run the instance
aws ec2 run-instances --image-id $ami --count 1 --instance-type t2.micro --key-name demokp --security-group-ids $sshsg --subnet-id $sub
#capture instance id
#associate the alloc id
aws ec2 associate-address --instance-id $instanceid --allocation-id $allocid
#tag the resource:
aws ec2 create-tags --resources $instanceid --tags Key=Stack,Value=production



#add cleanup as well
