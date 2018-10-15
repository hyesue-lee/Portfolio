/**
 *  공통 스크립트
 */

function movePage(target, url, params){
   if(console){
      console.log(target);
      console.log(url);
      console.log(params);
   }
   
   if(params == undefined) params = {};
   if(target != null){
      
   }
   
   if($('#home').hasClass("active")){
      $('#home').removeClass("active");
   }
   
   $.ajax({
      url : ctx + url,
      data : params,
      success : function(data, status, XMLHttpRequest){
         history.pushState({url, params}, null, ctx + '/index.do'); // 히스토리 저장 
         $('div#contentDiv').html(data);
         
         // 검색시 search type, text 남기기
         if(params.pageName == "search") {
            $('#searchText').val(params.searchText);
            params.searchType -= 1;//??????????
            $('#searchType').find('option:eq('+params.searchType+')').prop("selected", true);
         }
      },
      error : function(XMLHttpRequest, status, errorThrows){
         console.log(XMLHttpRequest.responseText);
         $('div#contentDiv').html(XMLHttpRequest.responseText);
      }
   });
}

function movePageBack(target, url, params){
   if(console){
      console.log(target);
      console.log(url);
      console.log(params);
   }
   
   if(params == undefined) params = {};
   if(target != null){
      
   }
   
   if($('#home').hasClass("active")){
      $('#home').removeClass("active");
   }
   
   $.ajax({
      url : ctx + url,
      data : params,
      success : function(data, status, XMLHttpRequest){
         $('div#contentDiv').html(data);
         
         // 검색시 분류와 검색어 남기기
         if(params.pageName == "search") {
            $('#searchText').val(params.searchText);
            params.searchType -= 1;
            $('#searchType').find('option:eq('+params.searchType+')').prop("selected", true);
         }
      },
      error : function(XMLHttpRequest, status, errorThrows){
         console.log(XMLHttpRequest.responseText);
         $('div#contentDiv').html(XMLHttpRequest.responseText);
      }
   });
}