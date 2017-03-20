<!DOCTYPE html>
<%@ Page Language="C#" %>
<% this.SessionValue.Value = Session["SessionID"].ToString(); %>
<html>
<head>
<title>Image and PDF OCR Online | Dynamsoft</title>
<meta http-equiv="description" content="OCR PDF and images online at server side with the demo of Dymamsoft OCR Professional Module." />
<link href="Style/style_upload.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" language="javascript" src="Resources/dynamsoft.webtwain.config.js"></script>
<script type="text/javascript" language="javascript" src="Resources/dynamsoft.webtwain.initiate.js"></script>
</head>

<body>
<div id="main">
    <div id="divDownloadSDK">
        <div id="divCaption" class="cl">
            <div id="divCaptionLeft">
                <div id="dbrLogo"> <img src="Images/icon-DWT.png" alt="DBR Logo"> </div>
                <div class="navLink">
                    <div> <a target="_blank" class="bluelink" href="http://www.dynamsoft.com">Dynamsoft</a><span> / </span> <a target="_blank" class="bluelink" href="http://www.dynamsoft.com/Products/WebTWAIN_Overview.aspx">Dynamic Web TWAIN</a><span> / </span> <a target="_blank" class="bluelink" href="http://www.dynamsoft.com/Downloads/WebTWAIN-Sample-Download.aspx">code gallery</a></div>
                    <div class="displayBlock mt10"> <span id="desc1">Upload PDF or Images and Perform Server-side OCR</span> </div>
                </div>
            </div>
            <div id="divCaptionRight"> <a target="_blank" href="http://www.dynamsoft.com/Downloads/WebTWAIN_Download.aspx" class="largeBtnOrg">Download SDK</a> </div>
            <div id="divSampleDesc" class="cl"> <span class="blackGrayFont16">The sample demonstrates how to load local PDFs or images with Dynamic Web TWAIN, upload them to server and then perform server-side OCR.</span> </div>
        </div>
    </div>
    <div class="minHeight40"></div>
    <div id="divOCR">
        <div style="display:none"> 
            <!-- dwtcontrolContainer is the default div id for Dynamic Web TWAIN control.
             If you need to rename the id, you should also change the id in the dynamsoft.webtwain.config.js accordingly. -->
            <div id="dwtcontrolContainer"></div>
        </div>
        <div>
            <div>
                <div>
                    <label class="lblOCR">Upload PDF or image:</label>
                    <label class="lblOCR ctlRight" style="margin-left:97px;">Language:</label>
                </div>
                <div>
                    <input name="txtUploadFileName" type="text" readonly id="txtUploadFileName" class="ImgURL"/>
                    <input type="button" id="btnUploadFile" value="" onclick="selectFile();" title="supported format: tiff (G4 / LZW / jpeg), jpeg, PDF,BMP,jpep2000, jbig, jbig2, png, pda, pgx, xps, wmp, opg, max, awd, dcx, pcx"/>
                    <img title = "supported format: tiff (G4 / LZW / jpeg), jpeg, PDF,BMP,jpep2000, jbig, jbig2, png, pda, pgx, xps, wmp, opg, max, awd, dcx, pcx" alt = "supported format: tiff (G4 / LZW / jpeg), jpeg, PDF,BMP,jpep2000, jbig, jbig2, png, pda, pgx, xps, wmp, opg, max, awd, dcx, pcx" style="border:none;" src="Images/faq 16.png"/>
                    <select size="1" id="ddlLanguages" class="selectOCR ctlRight" style="margin-left: 74px;">
                    </select>
                </div>
            </div>
            <div>
                <div>
                    <label class="lblOCR">Recognition Mode:</label>
                    <label class="lblOCR ctlRight">Output Format:</label>
                </div>
                <div>
                    <select size="1" id="ddlOCRRecognitionModule" class="selectOCR">
                    </select>
                    <select size="1" id="ddlOCROutputFormat" class="selectOCR ctlRight" onchange="SetIfUseRedaction();">
                    </select>
                </div>
            </div>
            <div id="divVersion" style="display:none">
                <div>
                    <label class="lblOCR">PDF Version:</label>
                    <label class="lblOCR ctlRight">PDF/A Version:</label>
                </div>
                <div>
                    <select size="1" id="ddlPDFVersion"  class="selectOCR">
                    </select>
                    <select size="1" id="ddlPDFAVersion" class="selectOCR ctlRight">
                    </select>
                </div>
            </div>
            <div id= "divIfUseRedaction" style="display:none";>
                <input type="checkbox" id="chkUseRedaction" class="chkOCR" onclick="SetRedaction();" />
                <label class="lblCheckBox" for="chkUseRedaction">Search Text and Redact</label>
            </div>
            <div>
                <div id="divLblFindTXT" style="display:none">
                    <label class="lblOCR">Find Text:</label>
                    <label class="lblOCR ctlRight">Match Mode:</label>
                </div>
                <div id="divCtrlFindTXT" style="display:none">
                    <input type="text" id= "txtFindText" value="" class="txtOCR" />
                    <select size="1" id="ddlFindTextFlags" class="selectOCR ctlRight">
                    </select>
                </div>
                <div id="divLblTXTAction" style="display:none">
                    <label class="lblOCR">Find Text Action:</label>
                </div>
                <div>
                    <select size="1" id="ddlFindTextAction" class="selectOCR" style="display:none">
                    </select>
                    <label id="lblBtnOCR" class="lblOCR" style="height:50px;"></label>
                    <input type="button" value="OCR" onclick="DoOCR();" class="btnOCR" />
                    <span id="spOCRResult" style="display:none;" class="lblOCRResult">(<a id="aOCRResult" href="" target="_blank"><u>OCR Result</u></a>)</span> </div>
            </div>
        </div>
    </div>
    <input type="hidden" id="SessionValue" runat="server" />
</div>
<script type="text/javascript">
        Dynamsoft.WebTwainEnv.RegisterEvent('OnWebTwainReady', Dynamsoft_OnReady); // Register OnWebTwainReady event. This event fires as soon as Dynamic Web TWAIN is initialized and ready to be used


        var DWObject;

        var OCRFindTextFlags = [
                { desc: "whole word", val: 1 },
                { desc: "match case", val: 2 },
                { desc: "fuzzy match", val: 4 }
        ];


        var OCRFindTextAction = [
                { desc: "highlight", val: 0 },
                { desc: "strikeout", val: 1 },
                { desc: "mark for redact", val: 2 }
        ];


        var OCRLanguages = [
                { desc: "English", val: "eng" },
                { desc: "Arabic", val: "arabic" },
                { desc: "Italian", val: "italian" }
        ];   
                
        var OCRRecognitionModule = [
                { desc: "auto", val: "AUTO" },
                { desc: "most accurate", val: "MOSTACCURATE" },
                { desc: "balanced", val: "BALANCED" },
                { desc: "fastest", val: "FASTEST" }
        ];   
             
        var OCROutputFormat = [
                { desc: "TXT", val: "TXTS" },
                { desc: "CSV", val: "TXTCSV" },
                { desc: "Text Formatted", val: "TXTF" },
                { desc: "XML", val: "XML" },
                { desc: "PDF", val: "IOTPDF" },
                { desc: "PDF with MRC compression", val: "IOTPDF_MRC" }
        ];

        var OCRPDFVersion = [
                { desc: "", val: "" },
                { desc: "1.0", val: "1.0" },
                { desc: "1.1", val: "1.1" },
                { desc: "1.2", val: "1.2" },
                { desc: "1.3", val: "1.3" },
                { desc: "1.4", val: "1.4" },
                { desc: "1.5", val: "1.5" },
                { desc: "1.6", val: "1.6" },
                { desc: "1.7", val: "1.7" }

        ];

        var OCRPDFAVersion = [
                { desc: "", val: "" },
                { desc: "pdf/a-1a", val: "pdf/a-1a" },
                { desc: "pdf/a-1b", val: "pdf/a-1b" },
                { desc: "pdf/a-2a", val: "pdf/a-2a" },
                { desc: "pdf/a-2b", val: "pdf/a-2b" },
                { desc: "pdf/a-2u", val: "pdf/a-2u" },
                { desc: "pdf/a-3a", val: "pdf/a-3a" },
                { desc: "pdf/a-3b", val: "pdf/a-3b" },
                { desc: "pdf/a-3u", val: "pdf/a-3u" }

        ];
           
        function Dynamsoft_OnReady() {
            DWObject = Dynamsoft.WebTwainEnv.GetWebTwain('dwtcontrolContainer'); // Get the Dynamic Web TWAIN object that is embeded in the div with id 'dwtcontrolContainer'
            if (DWObject) {
                for (var i = 0; i < OCRFindTextFlags.length; i++)
                    document.getElementById("ddlFindTextFlags").options.add(new Option(OCRFindTextFlags[i].desc, i));
                for (var i = 0; i < OCRFindTextAction.length; i++)
                    document.getElementById("ddlFindTextAction").options.add(new Option(OCRFindTextAction[i].desc, i));                  
                for (var i = 0; i < OCRLanguages.length; i++)
                    document.getElementById("ddlLanguages").options.add(new Option(OCRLanguages[i].desc, i));
                for (var i = 0; i < OCROutputFormat.length; i++)
                    document.getElementById("ddlOCROutputFormat").options.add(new Option(OCROutputFormat[i].desc, i));
                for (var i = 0; i < OCRRecognitionModule.length; i++)
                    document.getElementById("ddlOCRRecognitionModule").options.add(new Option(OCRRecognitionModule[i].desc, i));
                for (var i = 0; i < OCRPDFVersion.length; i++)
                    document.getElementById("ddlPDFVersion").options.add(new Option(OCRPDFVersion[i].desc, i));
                for (var i = 0; i < OCRPDFAVersion.length; i++)
                    document.getElementById("ddlPDFAVersion").options.add(new Option(OCRPDFAVersion[i].desc, i));

                document.getElementById("ddlPDFVersion").selectedIndex = 6;
                
                DWObject.RegisterEvent('OnGetFilePath', OnGetFilePath);
            }
        }

        function AcquireImage() {
            if (DWObject) {
                var bSelected = DWObject.SelectSource();
                if (bSelected) {

                    var OnAcquireImageSuccess, OnAcquireImageFailure;
                    OnAcquireImageSuccess = OnAcquireImageFailure = function() {
                        DWObject.CloseSource();
                    };

                    DWObject.OpenSource();
                    DWObject.IfDisableSourceAfterAcquire = true;  //Scanner source will be disabled/closed automatically after the scan.
                    DWObject.AcquireImage(OnAcquireImageSuccess, OnAcquireImageFailure);
                }
            }
        }

        function SetIfUseRedaction() {
            var selectValue = OCROutputFormat[document.getElementById("ddlOCROutputFormat").selectedIndex].val;
            if (selectValue == "IOTPDF" ||
                selectValue == "IOTPDF_MRC") {
                document.getElementById("divVersion").style.display = "";
                document.getElementById("divIfUseRedaction").style.display = "";
            }
            else if(selectValue == "TXTF") {
                document.getElementById("divVersion").style.display = "none";
                document.getElementById("divIfUseRedaction").style.display = "";
            }
            else {
                document.getElementById("divVersion").style.display = "none";
                document.getElementById("divIfUseRedaction").style.display = "none";
                document.getElementById("divLblFindTXT").style.display = "none";
                document.getElementById("divCtrlFindTXT").style.display = "none";
                document.getElementById("divLblTXTAction").style.display = "none";
                document.getElementById("ddlFindTextAction").style.display = "none";
                document.getElementById("lblBtnOCR").style.display = "";      
                document.getElementById("chkUseRedaction").checked = false;
            }
        }

        function SetRedaction() {
            if (document.getElementById("chkUseRedaction").checked) {
                document.getElementById("divLblFindTXT").style.display = "";
                document.getElementById("divCtrlFindTXT").style.display = "";
                document.getElementById("divLblTXTAction").style.display = "";
                document.getElementById("ddlFindTextAction").style.display = "";
                document.getElementById("lblBtnOCR").style.display = "none";    
            }
            else {
                document.getElementById("divLblFindTXT").style.display = "none";
                document.getElementById("divCtrlFindTXT").style.display = "none";
                document.getElementById("divLblTXTAction").style.display = "none";
                document.getElementById("ddlFindTextAction").style.display = "none";
                document.getElementById("lblBtnOCR").style.display = "";    
                document.getElementById("chkUseRedaction").checked = false;
            }
        }
        
        var vSessionID;
        function DoOCR() {
            document.getElementById("spOCRResult").style.display = "none";
            if (DWObject) {
                 var upLoadFile = document.getElementById("txtUploadFileName");
                if (upLoadFile.value.length == 0) {
                    alert("Please upload pdf or image first.");
                    return;
                }
                
                var OnSuccess = function(httpResponse) {
                };


                var OnFailure = function(errorCode, errorString, httpResponse) {
                     if (errorCode != -2003) {
                        alert(errorString);
                        return;
                    }
                    
                    var outPutFile, response = "";
                    var pos = httpResponse.indexOf("|#|");
                    if (pos < 0)
                        response = httpResponse;
                    else {
                        if (pos > 0)
                            outPutFile = httpResponse.substring(0, pos);
                            
                        if (httpResponse && httpResponse.length > 3)
                            response = httpResponse.substring(pos + 3, httpResponse.length);
                    }
                  
                    if (outPutFile && outPutFile.length > 0) {
                        var downloadURL = GetDownloadURL(outPutFile);
                        if (downloadURL)
                        {
                            var dOCRResult = document.getElementById("spOCRResult");
                            if(dOCRResult)
                            {
                                dOCRResult.style.display = "";
                                var aOCRResult = document.getElementById("aOCRResult");
                                if(aOCRResult)
                                {
                                    aOCRResult.href = downloadURL;
                                }                             
                            } 
                        }
                    }
                    else {
                        var result;
                        if (response && response.length > 0) {
                            try {
                                result = KISSY.JSON.parse(response);
                            }
                            catch (exp) {
                                alert(response);
                                return;
                            }

                        }
                        if (result && result.message) {
                            var strErrorDetail = result.message;
                            var aryErrorDetailList = result.errorList;
                            if (aryErrorDetailList.length > 0)
                                strErrorDetail = strErrorDetail + "\r\nError lists:\r\n";
                            for (var i = 0; i < aryErrorDetailList.length; i++) {
                                if (i > 0)
                                    strErrorDetail += ";";
                                strErrorDetail += "[" + (i + 1) + "]." + aryErrorDetailList[i].input + ": " + aryErrorDetailList[i].message;
                            }
                            alert(strErrorDetail);
                        }
                        else
                            alert("OCR failed.");
                    }        
                };

               DWObject.MaxUploadImageSize = 5000000;
               var date = new Date();
               var strFilePath = date.getFullYear() + "_" + (date.getMonth()+1) + "_" + date.getDate() + "_" + date.getHours() + "_" + date.getMinutes() + "_" + date.getSeconds() + "_" + date.getMilliseconds()+ ".pdf";

               var strHTTPServer = location.hostname;
               DWObject.IfSSL = DynamLib.detect.ssl;
               var _strPort = location.port == "" ? 80 : location.port;
               if (DynamLib.detect.ssl == true)
                   _strPort = location.port == "" ? 443 : location.port;
               DWObject.HTTPPort = _strPort;


               var currentPathName = unescape(location.pathname); // get current PathName in plain ASCII
               var currentPath = currentPathName.substring(0, currentPathName.lastIndexOf("/") + 1);
               var strActionPage = currentPath + "SaveToOCR.aspx"; //the ActionPage's file path , Online Demo:"SaveToDB.aspx" ;Sample: "SaveToFile.aspx";

               strHTTPServer = location.hostname;

               DWObject.ClearAllHTTPFormField();
               var outputFormat = OCROutputFormat[document.getElementById("ddlOCROutputFormat").selectedIndex].val;
               DWObject.SetHTTPFormField("OutputFormat", outputFormat);
               DWObject.SetHTTPFormField("RequestBody", GetRequestBody());
               vSessionID = document.getElementById("SessionValue").value.toString();
               DWObject.SetHTTPFormField("SessionID", vSessionID);
                DWObject.HTTPUploadThroughPostDirectly(
                  strHTTPServer, 
                  upLoadFile.value,
                  strActionPage, 
                  strFilePath, 
                  OnSuccess, OnFailure);             
            }
        }

        function GetRequestBody() {
            var strRequestBody = "{";
            strRequestBody += "\"productKey\": \"" + Dynamsoft.WebTwainEnv.ProductKey + "\",";
            strRequestBody += "\"inputFile\":[\"******\"],";
            strRequestBody += "\"settings\": {";
            strRequestBody += "\"recognitionModule\": \"" + OCRRecognitionModule[document.getElementById("ddlOCRRecognitionModule").selectedIndex].val + "\",";
            strRequestBody += "\"languages\": \"" + OCRLanguages[document.getElementById("ddlLanguages").selectedIndex].val + "\",";
            var strSavePath = document.getElementById("txtOutputpath");
            strRequestBody += "\"recognitionMethod\": \"Page\","; 
            strRequestBody += "\"threadCount\": \"2\",";
            strRequestBody += "\"outputFormat\": \"" + OCROutputFormat[document.getElementById("ddlOCROutputFormat").selectedIndex].val + "\"";
            var selectValue = OCROutputFormat[document.getElementById("ddlOCROutputFormat").selectedIndex].val;
            if (selectValue == "IOTPDF" ||
                selectValue == "IOTPDF_MRC") {
                strRequestBody += "," + "\"pdfVersion\": \"" + OCRPDFVersion[document.getElementById("ddlPDFVersion").selectedIndex].val + "\",";
                strRequestBody += "\"pdfAVersion\": \"" + OCRPDFAVersion[document.getElementById("ddlPDFAVersion").selectedIndex].val + "\"";
            }
            if (document.getElementById("chkUseRedaction").checked) {
                strRequestBody += ",\"redaction\":{";
                strRequestBody += "\"findText\":\"" + document.getElementById("txtFindText").value + "\",";
                strRequestBody += "\"findTextFlags\":" + OCRFindTextFlags[document.getElementById("ddlFindTextFlags").selectedIndex].val + ",";
                strRequestBody += "\"findTextAction\":" + OCRFindTextAction[document.getElementById("ddlFindTextAction").selectedIndex].val;
                strRequestBody += "}";
            }
            strRequestBody += "},";
            strRequestBody += "\"zones\": [],";  //"\"zones\": [[100,100,200,300],[100,600,100,200]],";

            strRequestBody += "\"outputFile\": \"$$$$$$\"";
            strRequestBody += "}";
            return strRequestBody;
        }

        function GetDownloadURL(outPutFile) {
            var downloadURLTemp = "";
            var findText = "UploadedImages\\";
            var filename = outPutFile;
            var pos = outPutFile.indexOf(findText);
            if (pos > 0)
                filename = outPutFile.substring(pos + findText.length, outPutFile.length);
                
            var _strPort = location.port == "" ? 80 : location.port;
            if (DynamLib.detect.ssl == true) {
                _strPort = location.port == "" ? 443 : location.port;
                downloadURLTemp = "https://";
            }
            else
                downloadURLTemp = "http://";

            var currentPathName = unescape(location.pathname); // get current PathName in plain ASCII
            var currentPath = currentPathName.substring(0, currentPathName.lastIndexOf("/") + 1);
            var strDownloadPage = currentPath + "UploadedImages/" + filename;

            downloadURLTemp = downloadURLTemp + location.hostname + ":" + _strPort + strDownloadPage;

            return downloadURLTemp;
        }
        
        function selectFile()
        {   
            var upLoadFile = document.getElementById("txtUploadFileName");
            upLoadFile.value = "";
             if (DWObject) {
                DWObject.IfShowFileDialog = false;       
                DWObject.ShowFileDialog(false, "", 0, "", "", false, true, 0);
            }
        }
        
        function OnGetFilePath(bSave, filesCount, index, path, filename){
            if(bSave == false)
            {
                if(index >= 0)
                {
                    var upLoadFile = document.getElementById("txtUploadFileName");
                    upLoadFile.value += path+'\\'+filename;
                }
            }
        }
        
        var xmlhttp;
        function loadXMLDoc(url)
        {
            xmlhttp = null;
            if(window.XMLHttpRequest)
                xmlhttp = new XMLHttpRequest();
                
            if(xmlhttp != null)
            {
                xmlhttp.onreadystatechange=state_change;
                xmlhttp.open("POST", url, true);
                xmlhttp.send();
            }
            else
                alert("Your browser does not support XMLHTTP");
        }
        function state_change()
        {
            if(xmlhttp.readyState == 4)
            {
                if(xmlhttp.status == 200)
                {
                    
                }
                else
                {
                    //alert("problem retrieving XML data");
                }
            }
        }
        
        function deleteOCRResult() {
            if (vSessionID) {
                var serverURL = "";
                var _strPort = location.port == "" ? 80 : location.port;
                if (DynamLib.detect.ssl == true) {
                    _strPort = location.port == "" ? 443 : location.port;
                    serverURL = "https://";
                }
                else {
                    serverURL = "http://";
                }

                var CurrentPathName = unescape(location.pathname); // get current PathName in plain ASCII
                var CurrentPath = CurrentPathName.substring(0, CurrentPathName.lastIndexOf("/") + 1);
                var strActionPage = CurrentPath + "/DeleteFiles.aspx?TestID=" + vSessionID;

                serverURL = serverURL + location.hostname + ":" + _strPort + strActionPage;
                loadXMLDoc(serverURL);
            }
        }

        window.onbeforeunload = function() {
            deleteOCRResult();
        } 
      
    </script>
</body>
</html>
