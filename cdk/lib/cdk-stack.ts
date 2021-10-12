import * as cdk from "@aws-cdk/core";
import * as ecr from "@aws-cdk/aws-ecr";
import * as iam from "@aws-cdk/aws-iam"
import * as lambda from "@aws-cdk/aws-lambda";
import { HttpApi, HttpMethod } from '@aws-cdk/aws-apigatewayv2'
import { LambdaProxyIntegration } from "@aws-cdk/aws-apigatewayv2-integrations";
import { Duration } from "@aws-cdk/core";

export class CdkStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    
    const httpApi = new HttpApi(this, "HttpAPI", {
      description: 'Http API for Lambda functions'
    });

    // Amazon ECR 
    const repository = new ecr.Repository(this, "MyFunctionECR", {
      repositoryName: "myfunction",
      imageScanOnPush: true,
      removalPolicy: cdk.RemovalPolicy.DESTROY
    });

    // const myfunction = new lambda.DockerImageFunction(this, 'Lambda', {
    //  functionName: "myfunction",
    //  code: lambda.DockerImageCode.fromEcr(repository),
    // });
    // myfunction.role?.addManagedPolicy(
    //   iam.ManagedPolicy.fromAwsManagedPolicyName('CloudWatchLambdaInsightsExecutionRolePolicy')
    // );

    // httpApi.addRoutes({
    //   path: '/myfunction',
    //   methods: [HttpMethod.ANY],
    //   integration: new LambdaProxyIntegration({
    //     handler: myfunction,
    //   }),
    // });

    // Amazon ECR 
    const lambdaInferenceRepository = new ecr.Repository(this, "LambdaInferenceECR", {
      repositoryName: "lambda-inference",
      imageScanOnPush: true,
      removalPolicy: cdk.RemovalPolicy.DESTROY
    });

    // const lambdaInferenceFunction = new lambda.DockerImageFunction(this, 'LambdaInference', {
    //   functionName: "lambda-inference",
    //   code: lambda.DockerImageCode.fromEcr(lambdaInferenceRepository),
    //   memorySize: 1024,
    //   timeout: Duration.seconds(60)
    //  });
    //  lambdaInferenceFunction.role?.addManagedPolicy(
    //    iam.ManagedPolicy.fromAwsManagedPolicyName('CloudWatchLambdaInsightsExecutionRolePolicy')
    //  );

    //  httpApi.addRoutes({
    //   path: '/infer',
    //   methods: [HttpMethod.ANY],
    //   integration: new LambdaProxyIntegration({
    //     handler: lambdaInferenceFunction,
    //   }),
    // });
  }
}
