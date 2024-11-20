using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebFormsJQueryPromises.Pages
{
    public partial class JQueryPromises : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Carrega os dados no GridView
            if (!IsPostBack)
            {
                var data = new List<object>(); 
                for (int i = 100; i <= 200; i++)
                {
                    data.Add(new { Id = i, DocId = 9 + i, Nome = $"Doc {i}" });
                }
                GridView1.DataSource = data;
                GridView1.DataBind();
            }
        }

        [WebMethod]
        public static void ProcessItem(int id)
        {
            // Exemplo de operação demorada
            System.Threading.Thread.Sleep(1000);
            // Aqui você pode processar o item com o ID recebido, por exemplo, salvar ou atualizar dados no banco
            Console.WriteLine($"Processando ID: {id}");
        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
        }
    }
}