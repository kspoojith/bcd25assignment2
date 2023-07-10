using Ardalis.GuardClauses;
using Microsoft.Extensions.Options;
using StackExchange.Redis;

namespace LeaderBoard.SharedKernel.Redis;

public static class Extensions
{
    public static WebApplicationBuilder AddCustomRedis(this WebApplicationBuilder builder)
    {
        builder.Services.AddOptions<RedisOptions>().BindConfiguration(nameof(RedisOptions));
        builder.Services.AddSingleton<IConnectionMultiplexer>(sp =>
        {
            var redisOptions = sp.GetService<IOptions<RedisOptions>>()?.Value;
            Guard.Against.Null(redisOptions);

            return ConnectionMultiplexer.Connect(
                new ConfigurationOptions
                {
                    EndPoints = { $"{redisOptions.Host}:{redisOptions.Port}" }
                }
            );
        });

        return builder;
    }
}
