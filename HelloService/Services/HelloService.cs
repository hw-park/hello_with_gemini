using Grpc.Core;
using HelloService;

namespace HelloService.Services;

public class HelloService : Hello.HelloBase
{
    public override Task<HelloResponse> GetResponse(HelloRequest request, ServerCallContext context)
    {
        return Task.FromResult(new HelloResponse
        {
            Response = "Hello, " + request.Request
        });
    }
}