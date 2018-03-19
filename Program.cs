using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace cryptool
{
    class Program
    {
        static HttpClient client = new HttpClient();
        static string ArgsResolver(string[] args)
        {
            if(args.Any() && Regex.IsMatch(args[0], "^[a-zA-Z]{3}$"))
                return $"/{args[0]}";
            
            return string.Empty;
        }

        static async Task Main(string[] args)
        {
            var uri = $"https://api.coindesk.com/v1/bpi/currentprice{ArgsResolver(args)}.json";

            var result = await client.GetAsync(uri);
            var content = await result.Content.ReadAsStringAsync();

            if (result.StatusCode != HttpStatusCode.OK)
            {
                Console.WriteLine("Ocorreu um problema 😬");
                Console.ForegroundColor = ConsoleColor.Red;
            }

            Console.WriteLine(content);          
        }
    }
}
