<!DOCTYPE html>
<%@ Page Language="C#" %>
<% this.SessionValue.Value = Session["SessionID"].ToString(); %>
<html>
<head>
<title>Online OCR | Dynamic Web TWAIN SDK | Dynamsoft</title>
<meta http-equiv="description" content="The sample demonstrates how to scan documents or import local images with Dynamic Web TWAIN, upload them to server and then perform server-side OCR." />
<link href="Style/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" language="javascript" src="Scripts/Common.js"></script>
<script type="text/javascript" language="javascript" src="Resources/dynamsoft.webtwain.config.js"></script>
<script type="text/javascript" language="javascript" src="Resources/dynamsoft.webtwain.initiate.js"></script>
</head>

<body>
<div id="serverSide">
    <div id="header">
        <div class="container">
            <div id="headerTop" class="row">
                <div class="ct-lt fl clearfix">
                    <div class="logo mr20 fl"> <img src="Images/logo-dwt-56x56.png" alt="Dynamic WEB TWAIN Logo"> </div>
                    <div class="fl">
                        <div class="linkGroup"> <a target="_blank" class="bluelink fontSize14" href="http://www.dynamsoft.com">Dynamsoft</a><span> / </span> <a target="_blank" class="bluelink fontSize14" href="http://www.dynamsoft.com/Products/WebTWAIN_Overview.aspx">Dynamic Web TWAIN</a><span> / </span> <a target="_blank" class="bluelink fontSize14" href="http://www.dynamsoft.com/Downloads/WebTWAIN-Sample-Download.aspx">code gallery</a><span> / </span> </div>
                        <h1>Scan Documents and Server-side OCR</h1>
                    </div>
                </div>
                <div class="ct-rt fr"> <a class="d-btn lgBtn bgOrange" target="_blank" href="http://www.dynamsoft.com/Downloads/WebTWAIN_Download.aspx">Download SDK</a> </div>
            </div>
            <div id="headerBtm" class="row">The sample demonstrates how to scan documents with Dynamic Web TWAIN, upload them to server and then perform server-side OCR using the <a class="bluelink" href="http://www.dynamsoft.com/Products/image-to-text-web-application.aspx">OCR Professional Module</a>.</div>
        </div>
    </div>
    <div id="main">
        <div class="container">
            <div class="ct-lt clearfix"> 
                <!-- dwtcontrolContainer is the default div id for Dynamic Web TWAIN control.
             If you need to rename the id, you should also change the id in the dynamsoft.webtwain.config.js accordingly. -->
                <div id="dwtcontrolContainer"></div>
            </div>
            <div class="ct-rt">
                <div class="content clearfix">
                    <div class="item">
                        <div class="left"> Select Source: </div>
                        <div class="right">
                            <select size="1" id="ddlSource" class="selectOCR">
                            </select>
                        </div>
                    </div>
                    <div class="item selectSource">
                        <div class="left">&nbsp;</div>
                        <div class="right">
                            <input type="button" value="Scan" onclick="AcquireImage();" class="btnScan d-btn" />
                        </div>
                    </div>
                    <div class="item">
                        <div class="left"> Language: </div>
                        <div class="right">
                            <select size="1" id="ddlLanguages" class="selectOCR">
                            </select>
                        </div>
                    </div>
                    <div class="item">
                        <div class="left"> Recognition Mode: </div>
                        <div class="right">
                            <select size="1" id="ddlOCRRecognitionModule" class="selectOCR">
                            </select>
                        </div>
                    </div>
                    <div class="item">
                        <div class="left"> Output Format: </div>
                        <div class="right">
                            <select size="1" id="ddlOCROutputFormat" class="selectOCR" onchange="SetIfUseRedaction();">
                            </select>
                        </div>
                    </div>
                    <div id="divVersion" style="display:none">
                        <div class="item">
                            <div class="left"> PDF Version: </div>
                            <div class="right">
                                <select size="1" id="ddlPDFVersion"  class="selectOCR">
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <div class="left"> PDF/A Version: </div>
                            <div class="right">
                                <select size="1" id="ddlPDFAVersion"  class="selectOCR">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div id= "divIfUseRedaction" style="display:none";>
                        <div class="item">
                            <div class="left">&nbsp;</div>
                            <div class="right">
                                <input type="checkbox" id="chkUseRedaction" class="chkOCR" onclick="SetRedaction();" />
                                <label class="blackGrayFont14">Search Text and Redact</label>
                            </div>
                        </div>
                    </div>
                    <div id= "divRedaction" style="display:none">
                        <div class="item">
                            <div class="left"> Find Text: </div>
                            <div class="right">
                                <input type="text" id= "txtFindText" value="" class="txtOCR" />
                            </div>
                        </div>
                        <div class="item">
                            <div class="left"> Match Mode: </div>
                            <div class="right">
                                <select size="1" id="ddlFindTextFlags" class="selectOCR">
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <div class="left"> Find Text Action: </div>
                            <div class="right">
                                <select size="1" id="ddlFindTextAction" class="selectOCR">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="left">&nbsp;</div>
                        <div class="right">
                            <input type="button" value="OCR" onclick="DoOCR();" class="btnOCR d-btn mdBtn bgBlue mt15" />
                            <span id="spOCRResult" style="display:none;" class="lblOCRResult">(<a id="aOCRResult" href="javascript:void(0)" target="_blank"><u>OCR Result</u></a>)</span> </div>
                    </div>
                    <div class="tc mt25"><a class="bluelink f14" href="http://www.dynamsoft.com/demo/OCR/OCR-PDF-Online.aspx">Upload PDF or Images and Perform Server-side OCR &rsaquo;</a></div>
                </div>
            </div>
            <input type="hidden" id="SessionValue" runat="server" />
        </div>
    </div>
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
         
        var iImageCaptureDriverType;  
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
                
                ua = navigator.userAgent.toLowerCase();
                var index = ua.indexOf('intel mac os x 10_12_0');
                var bMac10_12 = index != -1;
                
                if(bMac10_12)
                {
				    DWObject.ImageCaptureDriverType = 0;
				    iImageCaptureDriverType = 0;
				}
			    else
			    {
				    DWObject.ImageCaptureDriverType = 3;
				    iImageCaptureDriverType = 3;
				}
				    
				var twainsource = document.getElementById("ddlSource");
				
				var vCount = DWObject.SourceCount;
                if(!bMac10_12 && vCount == 0 && Dynamsoft.Lib.env.bMac)
                {
                    DWObject.CloseSourceManager();
                    DWObject.ImageCaptureDriverType = 0;
                    iImageCaptureDriverType = 0;
                    DWObject.OpenSourceManager();
                    vCount = DWObject.SourceCount;
                }
                
                twainsource.options.length = 0;
                for (var i = 0; i < vCount; i++) {
                    twainsource.options.add(new Option(DWObject.GetSourceNameItems(i), i));
                }
            }
        }

        function AcquireImage() {
            if (DWObject) {
                DWObject.SelectSourceByIndex(document.getElementById("ddlSource").selectedIndex);
                DWObject.CloseSource();
                DWObject.OpenSource();
                
                if(!Dynamsoft.Lib.env.bMac || iImageCaptureDriverType == 0)
                    DWObject.IfShowUI = true;
                else
                    DWObject.IfShowUI = false;
                    

                var OnAcquireImageSuccess, OnAcquireImageFailure;
                OnAcquireImageSuccess = OnAcquireImageFailure = function() {
                    DWObject.CloseSource();
                };

                DWObject.IfDisableSourceAfterAcquire = true;  //Scanner source will be disabled/closed automatically after the scan.
                DWObject.AcquireImage(OnAcquireImageSuccess, OnAcquireImageFailure);
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
                document.getElementById("divRedaction").style.display = "none";
                document.getElementById("chkUseRedaction").checked = false;
            }
        }

        function SetRedaction() {
            if (document.getElementById("chkUseRedaction").checked) {
                document.getElementById("divRedaction").style.display = "";
            }
            else {
                document.getElementById("divRedaction").style.display = "none";
                document.getElementById("chkUseRedaction").checked = false;
            }
        }

        var vSessionID;
        function DoOCR() {
            document.getElementById("spOCRResult").style.display = "none";         
            if (DWObject) {
                if (DWObject.HowManyImagesInBuffer == 0) {
                    alert("Please scan or load an image first.");
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
                        if (downloadURL) {
                            var dOCRResult = document.getElementById("spOCRResult");
                            if (dOCRResult) {
                                dOCRResult.style.display = "";
                                var aOCRResult = document.getElementById("aOCRResult");
                                if (aOCRResult) {
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

               //DWObject.MaxUploadImageSize = 5000000;

               var date = new Date();
               var strFilePath = date.getFullYear() + "_" + (date.getMonth()+1) + "_" + date.getDate() + "_" + date.getHours() + "_" + date.getMinutes() + "_" + date.getSeconds() + "_" + date.getMilliseconds()+ ".pdf";

               var strHTTPServer = location.hostname;
               DWObject.IfSSL = DynamLib.detect.ssl;
               var _strPort = location.port == "" ? 80 : location.port;
               if (DynamLib.detect.ssl == true)
                   _strPort = location.port == "" ? 443 : location.port;
               DWObject.HTTPPort = _strPort;


               var CurrentPathName = unescape(location.pathname); // get current PathName in plain ASCII
               var CurrentPath = CurrentPathName.substring(0, CurrentPathName.lastIndexOf("/") + 1);
               var strActionPage = CurrentPath + "SaveToOCR.aspx"; //the ActionPage's file path , Online Demo:"SaveToDB.aspx" ;Sample: "SaveToFile.aspx";

               strHTTPServer = location.hostname;

               DWObject.ClearAllHTTPFormField();
               var outputFormat = OCROutputFormat[document.getElementById("ddlOCROutputFormat").selectedIndex].val;
               DWObject.SetHTTPFormField("OutputFormat", outputFormat);
               DWObject.SetHTTPFormField("RequestBody", GetRequestBody());

               vSessionID = document.getElementById("SessionValue").value.toString();
               DWObject.SetHTTPFormField("SessionID", vSessionID);
               
               DWObject.HTTPUploadThroughPostAsMultiPagePDF(
                strHTTPServer,
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

            var CurrentPathName = unescape(location.pathname); // get current PathName in plain ASCII
            var CurrentPath = CurrentPathName.substring(0, CurrentPathName.lastIndexOf("/") + 1);
            var strDownloadPage = CurrentPath + "UploadedImages/" + filename;

            downloadURLTemp = downloadURLTemp + location.hostname + ":" + _strPort + strDownloadPage;

            return downloadURLTemp;
        }

        window.onbeforeunload = function() {
            deleteOCRResult();
        } 
        
       
    </script> 
<!--Choose language--> 
<script>
        window.onload = function(e) {
            var urlAnchor = window.location.hash.substring(1);
			var obj = document.getElementById("ddlLanguages");
			var len = obj.length;
			for(var i=0;i<len;i++){
				if(urlAnchor==obj.options[i].innerHTML){
					obj.options[i].selected = true;
					}
				}
        };
    </script> 
<!-- Google following Javascript tag --> 
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-19660825-1', 'auto');
  ga('require', 'displayfeatures');
  ga('send', 'pageview');

</script>
</body>
</html>
