<%@ Page Language="C#" %>
<%
    try
    {
        String strImageName;
        HttpFileCollection files = HttpContext.Current.Request.Files;
        HttpPostedFile uploadfile = files["RemoteFile"];
        //if (uploadfile.ContentLength > 5000000)
        //{
        //    Response.Write("The size of the images you are about to upload has exceeded the allowed size.");
        //    return;
        //}
        strImageName = uploadfile.FileName;
        Session["SessionID"] = System.Web.HttpContext.Current.Request.Form["SessionID"];
        string strInputFile = Server.MapPath(".") + "\\Images\\Collect";
        if (!System.IO.Directory.Exists(strInputFile))
        {
            System.IO.Directory.CreateDirectory(strInputFile);
        }
        DateTime now = DateTime.Now;
        string strData = now.ToString("yyyyMMdd_HHmmss_") + now.Millisecond + "_" + (new Random().Next() % 1000).ToString();
        strInputFile = strInputFile + "\\" + strData + uploadfile.FileName;
        uploadfile.SaveAs(strInputFile);
             
        string strOutputFormat = System.Web.HttpContext.Current.Request.Form["OutputFormat"];
        string strRequestBody = System.Web.HttpContext.Current.Request.Form["RequestBody"];
        strRequestBody = strRequestBody.Replace("******", strInputFile);

        string stroutputFile = Server.MapPath(".") + "\\UploadedImages\\" + Session["SessionID"];
        if (!System.IO.Directory.Exists(stroutputFile))
        {
            System.IO.Directory.CreateDirectory(stroutputFile);
        }
        
        string outPutFile = strInputFile;
        int pos = strInputFile.IndexOf(".pdf");
        string type = ".pdf";
        switch (strOutputFormat)
        {
            case "TXTS":
                type = ".txt";
                break;
            case "TXTF":
                type = ".rtf";
                break;
            case "TXTCSV":
                type = ".csv";
                break;
            case "XML":
                type = ".xml";
                break;
            case "IOTPDF":
            case "IOTPDF_MRC":
                type = ".pdf";
                break;
        }

        outPutFile = stroutputFile + "\\" + strData + type;
        
        strRequestBody = strRequestBody.Replace("$$$$$$", outPutFile);

        OCRProServer.DoOCRPro objDoOCRRro = new OCRProServer.DoOCRPro();
        string strResponse = objDoOCRRro.DoOCR(strRequestBody);
        if (System.IO.File.Exists(outPutFile))
            Response.Write(outPutFile);
        else
            Response.Write("");
        Response.Write("|#|");
        Response.Write(strResponse);
    }
    catch
    {
    }
    
    
%>