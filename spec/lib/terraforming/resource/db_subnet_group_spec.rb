require "spec_helper"

module Terraforming::Resource
  describe DBSubnetGroup do
    let(:client) do
      Aws::RDS::Client.new(stub_responses: true)
    end

    let(:db_subnet_groups) do
      [
        {
          subnets: [
            {
              subnet_status: "Active",
              subnet_identifier: "subnet-1234abcd",
              subnet_availability_zone: {
                name: "ap-northeast-1c"
              }
            },
            {
              subnet_status: "Active",
              subnet_identifier: "subnet-5678efgh",
              subnet_availability_zone: {
                name: "ap-northeast-1b"
              }
            }
          ],
          db_subnet_group_name: "hoge",
          vpc_id: "vpc-1234abcd",
          db_subnet_group_description: "DB subnet group hoge",
          subnet_group_status: "Complete"
        },
        {
          subnets: [
            {
              subnet_status: "Active",
              subnet_identifier: "subnet-9012ijkl",
              subnet_availability_zone: {
                name: "ap-northeast-1b"
              }
            },
            {
              subnet_status: "Active",
              subnet_identifier: "subnet-3456mnop",
              subnet_availability_zone: {
                name: "ap-northeast-1c"
              }
            }
          ],
          db_subnet_group_name: "fuga",
          vpc_id: "vpc-5678efgh",
          db_subnet_group_description: "DB subnet group fuga",
          subnet_group_status: "Complete"
        }
      ]
    end

    before do
      client.stub_responses(:describe_db_subnet_groups, db_subnet_groups: db_subnet_groups)
    end

    describe ".tf" do
      it "should generate tf" do
        expect(described_class.tf(client)).to eq <<-EOS
resource "aws_db_subnet_group" "hoge" {
    name        = "hoge"
    description = "DB subnet group hoge"
    subnet_ids  = ["subnet-1234abcd", "subnet-5678efgh"]
}

resource "aws_db_subnet_group" "fuga" {
    name        = "fuga"
    description = "DB subnet group fuga"
    subnet_ids  = ["subnet-9012ijkl", "subnet-3456mnop"]
}

        EOS
      end
    end

    describe ".tfstate" do
      it "should raise NotImplementedError" do
        expect do
          expect(described_class.tfstate(client))
        end.to raise_error NotImplementedError
      end
    end
  end
end
