<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JQueryPromises.aspx.cs" Inherits="WebFormsJQueryPromises.Pages.JQueryPromises" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Seleção com GridView</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.2/jquery.validate.min.js"></script>
    <style>
        .progress-bar {
            width: 100%;
            background-color: #f3f3f3;
            border: 1px solid #ddd;
            height: 20px;
            margin-top: 10px;
        }

        .progress-bar-fill {
            height: 100%;
            background-color: #4caf50;
            width: 0;
            transition: width 0.3s;
        }
    </style>
    <script type="text/javascript">
        function CheckAll(obj, valor) {
            $("input[id$='" + valor + "']").prop('checked', $(obj).is(':checked'));
        }

        function ValidarSelecao(item) {
            var count_checked = $("input[id$='" + item + "']:checked").length;
            if (count_checked > 0) {
                return true;
            }
            else {
                MensageBox('Nenhum registro selecionado!');
                return false;
            }
        }

        $(document).ready(function () {
            // Envia os IDs para o servidor e acompanha o progresso
            $('#processButton').on('click', function () {
                var itensChecked = $("input[id$='chkAss']:checked")

                if (itensChecked.length === 0) {
                    MensageBox('Nenhum registro selecionado!');
                    return false;
                }
                let selectedIds = [];
                itensChecked.map((index, item) => { selectedIds.push(index, item.attributes['data-id'].value) });

                let progressBarFill = $('.progress-bar-fill');
                progressBarFill.css('width', '0%');
                let totalRequests = selectedIds.length;
                let completedRequests = 0;

                // Função para atualizar o progresso
                function updateProgress() {
                    let percentage = (completedRequests / totalRequests) * 100;
                    progressBarFill.css('width', percentage + '%');
                }

                // Processa cada ID em paralelo com promises, limitando a 2 requests ao mesmo tempo
                let promises = [];
                for (let i = 0; i < selectedIds.length; i += 2) {
                    let batch = selectedIds.slice(i, i + 2).map(id => {
                        return $.ajax({
                            url: '../Handlers/JQueryPromises.ashx',
                            method: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify({ docSolId: id }),
                            success: function () {
                                completedRequests++;
                                updateProgress();
                            },
                            error: function () {
                                var msg = `Erro ao processar DocSolId: ${id}`;
                                alert(msg)
                                console.log(msg);
                            }
                        });
                    });
                    promises.push(...batch);
                }

                // Aguarda todas as promessas serem concluídas
                Promise.all(promises).then(function () {
                    alert('Processamento concluído!');
                });
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">

        <button type="button" id="processButton">Processar Selecionados</button>
        <div class="progress-bar">
            <div class="progress-bar-fill"></div>
        </div>
        <br>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnRowDataBound="GridView1_RowDataBound">
            <Columns>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:CheckBox ID="chkTodosAss" runat="server" onclick="CheckAll(this,'chkAss');" />
                    </HeaderTemplate>
                    <ItemTemplate>
                        <input id="chkAss" type="checkbox" class="select-item" data-id='<%# Eval("ID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Nome" HeaderText="Nome" />
            </Columns>
        </asp:GridView>
    </form>
</body>
</html>
