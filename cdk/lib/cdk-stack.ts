import * as cdk from "@aws-cdk/core";
import * as ecr from "@aws-cdk/aws-ecr";
import * as iam from "@aws-cdk/aws-iam"
import * as lambda from "@aws-cdk/aws-lambda";
import * as apigateway from "@aws-cdk/aws-apigateway";

export class CdkStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    
    // API Gateway
    const api = new apigateway.RestApi(this, "RestAPI", {
      restApiName: "myfunction-api",
      endpointConfiguration: {
        types: [apigateway.EndpointType.REGIONAL]
      },
      binaryMediaTypes: ["*/*"]
    });
    api.root.addMethod('ANY');

    // Amazon ECR 
    const repository = new ecr.Repository(this, "ECR", {
      repositoryName: "myfunction",
      imageScanOnPush: true,
      removalPolicy: cdk.RemovalPolicy.DESTROY
    });

    // const lambdafunction = new lambda.DockerImageFunction(this, 'Lambda', {
    //  functionName: "myfunction",
    //  code: lambda.DockerImageCode.fromEcr(repository),
    // });
    // lambdafunction.role?.addManagedPolicy(
    //   iam.ManagedPolicy.fromAwsManagedPolicyName('CloudWatchLambdaInsightsExecutionRolePolicy')
    // );

    // const myfunctions = api.root.addResource('myfunction')
    // const integration = new apigateway.LambdaIntegration(lambdafunction)
    // myfunctions.addMethod('ANY', integration);
  }
}
