using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

public class JQueryPromiseData
{
    public string docSolId { get; set; }
}


namespace WebFormsJQueryPromises.Handlers
{
    /// <summary>
    /// Descrição resumida de JQueryPromises
    /// </summary>
    
    public class JQueryPromises : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            // Exemplo de operação demorada
            System.Threading.Thread.Sleep(5*1000);
            
            string jsonContent;
            using (var reader = new StreamReader(context.Request.InputStream))
            {
                jsonContent = reader.ReadToEnd();
            }
            var requestData = JsonConvert.DeserializeObject<JQueryPromiseData>(jsonContent);
            dynamic responseData = new JObject();
            responseData.DocSolId = requestData.docSolId;
            responseData.status = "Assinado";

            context.Response.ContentType = "application/json";
            context.Response.Write(responseData);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}