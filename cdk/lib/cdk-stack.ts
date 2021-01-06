import * as cdk from "@aws-cdk/core";
import * as ecr from "@aws-cdk/aws-ecr"
import * as apigateway from "@aws-cdk/aws-apigateway"

export class CdkStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    
    // API Gateway
    const api = new apigateway.RestApi(this, "myfunction-api", {
      restApiName: "myfunction-api",
      endpointConfiguration: {
        types: [apigateway.EndpointType.REGIONAL]
      },
      binaryMediaTypes: ["*/*"]
    });
    api.root.addMethod('ANY');

    // Amazon ECR 
    const repository = new ecr.Repository(this, "myfunction", {
      imageScanOnPush: true
    });
  }
}
