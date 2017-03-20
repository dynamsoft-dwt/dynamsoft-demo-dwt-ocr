<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OCR-PDF-Online.aspx.cs" Inherits="OCRProServer.OCR_PDF_Online" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
        <head runat="server">
        <title>Image and PDF OCR Online | Dynamsoft</title>
        <meta http-equiv="description" content="OCR PDF and images online at server side with the demo of Dymamsoft OCR Professional Module." />
        <link href="Style/style_upload.css" type="text/css" rel="stylesheet" />
        <script type="text/javascript" language="javascript" src="Scripts/Common.js"></script>
        <script type="text/javascript" language="javascript" src="Scripts/kissy-min.js"></script>
        <script type="text/javascript">
        // Assign the page onload fucntion.
        function S_get(id) {
            return document.getElementById(id);
        }

        var S = KISSY;
        
        var dlgDoOCR;
       function Dynamsoft__OnclickCloseInstallEx() {
	        if (dlgDoOCR) {
                dlgDoOCR.hide();
            }
        }
        
      function GetErrorDialog(errorString, height)
        {
            var ObjString = "<div class=\"D-dailog-body-error round style=\"height:"+height+"\">";
            ObjString += "<div style=\"height:150px;position:relative;\">";
            ObjString += "<div style=\"height:30px;background-color: #f5f5f5;\">";
            ObjString += "<a href=\"javascript: void(0)\" style=\"text-decoration:none;\" class=\"ClosetblCanNotScan\"></a>";
            ObjString += "</div>";
            ObjString += "<div class=\"ErrorLogo\" alt=\"Dynamsoft Corporation\" border=\"0\"></div>";
            ObjString += "</div>";
            ObjString += "<div class=\"dwt-box-title\">"+errorString+"</div>";
            ObjString += "</div>";
            document.getElementById("strBody").innerHTML = ObjString;
            
            ShowWaitDialog(360, height);
            
            for (var i = 0; i < document.links.length; i++) {
                if (document.links[i].className == 'ClosetblCanNotScan') {
                    document.links[i].onclick = Dynamsoft__OnclickCloseInstallEx;
                }
            }
        }
        
       function ShowWaitDialog(varWidth, varHeight) {
        S.use("overlay", function(S, o) {

        dlgDoOCR = new o.Dialog({
                srcNode: "#J_waiting",
                width: varWidth,
                height: varHeight,
                closable: false,
                mask: true,
                align: {
                    points: ['cc', 'cc']
                }
            });
            dlgDoOCR.show();
		    run=1;
        });}
        

        </script>
        </head>
<body onload="initValue();">
  <div id="ocrPDF">
     <div class="D-dailog row round" id="J_waiting">
        <div id="strBody" runat=server></div>
     </div>
     <form id="form1" runat="server">
        <div id="header">
           <div class="container">
              <div id="headerTop" class="row">
                 <div class="ct-lt fl clearfix">
                    <div class="logo mr20 fl"><img id="dbrLogo" src="Images/logo-dwt-56x56.png" alt="Dynamic WEB TWAIN Logo"> </div>
                    <div class="fl">
                       <div class="linkGroup"> <a target="_blank" class="bluelink" href="http://www.dynamsoft.com">Dynamsoft</a><span> / </span> <a target="_blank" class="bluelink" href="http://www.dynamsoft.com/Products/WebTWAIN_Overview.aspx">Dynamic Web TWAIN</a><span> / </span> <a target="_blank" class="bluelink" href="http://www.dynamsoft.com/Downloads/WebTWAIN-Sample-Download.aspx">code gallery</a></div>
                       <h1>Upload PDF or Images and Perform Server-side OCR</h1> 
                    </div>
                 </div>
                 <div class="ct-rt fr"><a class="d-btn lgBtn bgOrange" target="_blank" href="http://www.dynamsoft.com/Downloads/WebTWAIN_Download.aspx">Download SDK</a> </div>
              </div>
              <div id="headerBtm" class="row">The sample demonstrates how to load a local PDF or image file, upload it to server and then perform server-side OCR. </div>
           </div>
       </div>
           
       <div id="main">
          <div class="container">
              <div class="ct-lt clearfix" style="display:none;"> 
                 <!-- dwtcontrolContainer is the default div id for Dynamic Web TWAIN control.
                 If you need to rename the id, you should also change the id in the dynamsoft.webtwain.config.js accordingly. -->
                 <div id="dwtcontrolContainer"></div>
              </div>
              
              <div class="ct-rt clearfix">
                    <div class="item">
                      <div class="top"><label class="lblOCR">Upload a PDF or image:</label></div>
                      <div class="btm">
                        <asp:FileUpload CssClass="ImgLocalPath"  ID="upLoadFile"  size="115%" 
                            style="width:278px; height:40px; filter:alpha(opacity=0);-moz-opacity:0;opacity:0; font-size:23px;position: absolute;Z-INDEX: 99999;" runat="server" onchange="txtUploadFileName.value = this.value;"/>
                        <asp:TextBox ID="txtUploadFileName" CssClass="ImgURL" ReadOnly="true" runat="server" ></asp:TextBox>
                        <input type="button" id="btnUploadFile" value="" title="supported format: tiff (G4 / LZW / jpeg), jpeg, PDF,BMP,jpep2000, jbig, jbig2, png, pda, pgx, xps, wmp, opg, max, awd, dcx, pcx"/>
                        <img title = "supported format: tiff (G4 / LZW / jpeg), jpeg, PDF,BMP,jpep2000, jbig, jbig2, png, pda, pgx, xps, wmp, opg, max, awd, dcx, pcx" alt = "supported format: tiff (G4 / LZW / jpeg), jpeg, PDF,BMP,jpep2000, jbig, jbig2, png, pda, pgx, xps, wmp, opg, max, awd, dcx, pcx" style="border:none;" src="Images/faq 16.png"/>  
                       </div>
                     </div>
                     <div class="item">
                       <div class="top"><label class="lblOCR">Language:</label></div>
                       <div class="btm"><select size="1" id="ddlLanguages" name="ddlLanguages" class="selectOCR ">
                                </select></div>
                     </div>
                    
                     <div class="item">
                       <div class="top"><label class="lblOCR">Recognition Mode:</label></div>
                       <div class="btm"><select size="1" id="ddlOCRRecognitionModule" name="ddlOCRRecognitionModule" class="selectOCR">
                                </select></div>
                     </div>
                     <div class="item">
                       <div class="top"><label class="lblOCR ">Output Format:</label></div>
                       <div class="btm"><select size="1" id="ddlOCROutputFormat" name ="ddlOCROutputFormat" class="selectOCR " onchange="SetIfUseRedaction();">
                                </select></div>
                     </div>

                  <div id="divVersion" style="display:none">
                     <div class="item">
                        <div class="top"><label class="lblOCR">PDF Version:</label></div>
                        <div class="btm"><select size="1" id="ddlPDFVersion" name="ddlPDFVersion" class="selectOCR"></select></div>
                     </div>
                     <div class="item">
                        <div class="top"><label class="lblOCR ">PDF/A Version:</label></div>
                        <div class="btm"><select size="1" id="ddlPDFAVersion" name="ddlPDFAVersion" class="selectOCR "></select></div>
                     </div>
                  </div>
                  
                  <div id= "divIfUseRedaction" style="display:none";>
                     <div class="item">
                        <input type="checkbox" id="chkUseRedaction" name="chkUseRedaction" class="chkOCR" onclick="SetRedaction();" />
                            <label class="lblCheckBox" for="chkUseRedaction">Search Text and Redact</label>
                     </div>
                     <div class="item">&nbsp;</div>
                  </div>
                  
                  <div id="divFindTXT" style="display:none">
                     <div class="item">
                        <div class="top"><label class="lblOCR">Find Text:</label></div>
                        <div class="btm"><input type="text" id= "txtFindText" name= "txtFindText" value="" class="txtOCR" /></div>
                     </div>
                     <div class="item">
                        <div class="top"><label class="lblOCR ">Match Mode:</label></div>
                        <div class="btm"><select size="1" id="ddlFindTextFlags" name="ddlFindTextFlags" class="selectOCR "></select></div>
                      </div>
                  </div>
                  <div id="divTXTAction" style="display:none">
                     <div class="item">
                       <div class="top"><label class="lblOCR">Find Text Action:</label></div>
                       <div class="btm"><select size="1" id="ddlFindTextAction" name="ddlFindTextAction" class="selectOCR"></select></div>
                     </div>
                  </div>
                  <div class="item pt30">
                      <label id="lblBtnOCR" class="lblOCR" style="height:50px;"></label>
                      <input type="button" value="OCR" onclick="ClickOCR();" class="btnOCR" />
                      <%=strOCRResult%>
                        <div style="display:none;">
                                    <input id="DoOCR" type="submit" style="display:none;height:22px; width:1px;margin-left:0px; float:left;" value="Open Image" name="AddImage"/>
                        </div>
                  </div>
                  <div style="border-top:solid 1px #ddd; float:left; margin-top:18px; padding-top:23px; width:83%;"><a class="bluelink f14" href="http://www.dynamsoft.com/demo/OCR/OCRProServerSide.aspx">Scan Documents and Server-side OCR &rsaquo;</a></div>
                </div>
             </div>
    </form>
  </div>
<script  type="text/javascript">
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
                { desc: "French", val: "french" },
                { desc: "Arabic", val: "arabic" },  
                { desc: "Spanish", val: "spanish" }, 
                { desc: "Portuguese", val: "port" },
                { desc: "German", val: "german" },
                { desc: "Italian", val: "italian" },
                { desc: "Russian", val: "russian" }
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
        
        function initValue()
        {
             for (var i = 0; i < OCRFindTextFlags.length; i++)
                document.getElementById("ddlFindTextFlags").options.add(new Option(OCRFindTextFlags[i].desc, OCRFindTextFlags[i].val));
            for (var i = 0; i < OCRFindTextAction.length; i++)
                document.getElementById("ddlFindTextAction").options.add(new Option(OCRFindTextAction[i].desc, OCRFindTextAction[i].val));                  
            for (var i = 0; i < OCRLanguages.length; i++)
                document.getElementById("ddlLanguages").options.add(new Option(OCRLanguages[i].desc, OCRLanguages[i].val));
            for (var i = 0; i < OCROutputFormat.length; i++)
                document.getElementById("ddlOCROutputFormat").options.add(new Option(OCROutputFormat[i].desc, OCROutputFormat[i].val));
            for (var i = 0; i < OCRRecognitionModule.length; i++)
                document.getElementById("ddlOCRRecognitionModule").options.add(new Option(OCRRecognitionModule[i].desc, OCRRecognitionModule[i].val));
            for (var i = 0; i < OCRPDFVersion.length; i++)
                document.getElementById("ddlPDFVersion").options.add(new Option(OCRPDFVersion[i].desc, OCRPDFVersion[i].val));
            for (var i = 0; i < OCRPDFAVersion.length; i++)
                document.getElementById("ddlPDFAVersion").options.add(new Option(OCRPDFAVersion[i].desc, OCRPDFAVersion[i].val));

            document.getElementById("ddlPDFVersion").selectedIndex = 6;  
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
                document.getElementById("divFindTXT").style.display = "none";
                //document.getElementById("divCtrlFindTXT").style.display = "none";
                document.getElementById("divTXTAction").style.display = "none";
                //document.getElementById("ddlFindTextAction").style.display = "none";
                document.getElementById("lblBtnOCR").style.display = "";      
                document.getElementById("chkUseRedaction").checked = false;
            }
        }
        
        function SetRedaction() {
            if (document.getElementById("chkUseRedaction").checked) {
                document.getElementById("divFindTXT").style.display = "";
                //document.getElementById("divCtrlFindTXT").style.display = "";
                document.getElementById("divTXTAction").style.display = "";
                //document.getElementById("ddlFindTextAction").style.display = "";
                document.getElementById("lblBtnOCR").style.display = "none";    
            }
            else {
                document.getElementById("divFindTXT").style.display = "none";
                //document.getElementById("divCtrlFindTXT").style.display = "none";
                document.getElementById("divTXTAction").style.display = "none";
                //document.getElementById("ddlFindTextAction").style.display = "none";
                document.getElementById("lblBtnOCR").style.display = "";    
                document.getElementById("chkUseRedaction").checked = false;
            }
        }
        
        function ClickOCR()
        {     
            if(document.getElementById("spOCRResult"))
                document.getElementById("spOCRResult").innerHTML = "";
            if(document.getElementById("txtUploadFileName").value != "")
            {
                showWaitDialog();
                document.getElementById('DoOCR').click();
            }
            else
                GetErrorDialog("Please upload a PDF or image first.", 300);
        }
        
        function showWaitDialog() {
            confirmFlag = 0;
            var ObjString = "<div style=\"margin:0 auto;width:100px;line-height:300px\"><img src=\"Images/loading.gif\" /></div>";			
			document.getElementById("strBody").innerHTML = ObjString;           
            ShowWaitDialog(360, 0);
        }  
        
        var confirmFlag = 1;
        var vSessionID;
        window.onbeforeunload = function() {
            vSessionID = '<%=SessionID%>';
            if(confirmFlag)
                deleteOCRResult();
        }      
       
    </script>
</body>
</html>
