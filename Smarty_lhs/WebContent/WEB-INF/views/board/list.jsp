<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type ="text/javascript">
	

	
	$(document).ready(function(){

		var msg = '${msg}';
		if(msg != '') alert(msg);

		//검색 
		$('#btnSearch').on('click', function(){
			
			var searchType = $('#searchType option:selected').val(); 
										//태그의 아이디 다음, 공백 -> 하위태그로.. 
			var searchText = $('#searchText').val();
			
			if(searchText == ''){
				alert("검색어를 입력하세요");
				return; 
			}
			if(searchText.length < 2 ){
				alert("두글자 이상 입력하세요 ");
				return; 
			}
			
			console.log(searchType);
			console.log(searchText);
			 
			var data = { // 배열로 데이터 생성- 키:밸류 순으로 값 넘김.. 
				searchType : searchType,
				searchText : searchText,
				pageName : "search" 
				// common.cs - movePage에 설정해놓은 내용..
				
			};
			
			//submit
			var frm = document.searchForm;
			console.log(frm);
			
			movePage(null, '/board/list.do', data); //data: searchType,Text params로 넘김.. 
			
		});//btnSearch
		//엔터에 버튼 click먹이기 . 
		$('#searchText').keypress(function(event){
		     if ( event.which == 13 ) { //which속성 - Enter Key: 13 
		         $('#btnSearch').click(); // 버튼클릭 수행. 
		         return false;
		     }
		}); //keypress 
	
	});//ready

	
</script>


</head>
<body>
<!-- -->
<section>

	<div class="container">
		<div>
			<h4>자유게시판  </h4>
		</div>
		
	<!-- SEARCH  -->	
			<form align="right" style="display:inline-flex;width:100%;" method ="get" name="searchForm">
				<div style="width:200px;margin-left:61%">
					<select class="form-control" name="searchType" id="searchType">
						<option value="title" selected="selected">제목</option>
						<option value="content">내용</option>
						<option value="memberNick">글쓴이</option>     
					</select>
				</div>
				<div style="width:400px;">
					<input type="text" id="searchText" name="searchText" class="form-control">
				</div>
				<div class="input-group-btn">
					<button id="btnSearch" class="btn btn-primary" type="button">
					<i class="fa fa-search"></i>
					</button>
				</div>
			</form>	
	<!-- /SEARCH  -->
	
		
	<!-- TABLE -->
		<div class="table-responsive">
			<table class="table table-sm">
				
					<colgroup>
									<col width="10%" />
									<col width="35%" />
									<col width="10%" />
									<col width="8%" />
									<col width="8%" />
									<col width="15%" />
									
				</colgroup>

				
				<thead>
					<tr>
						<th class="fw-30" align="center">&emsp;&emsp;&emsp;#</th>
						<th align="center">제목</th>
						<th align="center">글쓴이</th>
						<th align="center">조회수</th>
						<th align="center">첨부파일</th>
						<th align="center">작성일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list}" var="i">
                   		<tr>
                            <td align="center">${i.boardSeq}</td>
                            <td>
                            <span class="bold">
							<a href="javascript:movePage(null,'/board/read.do?boardSeq=${i.boardSeq }&page=${page}')">
							
							${i.title }</a></span>
                            </td>
                            <td>${i.memberNick }</td>
                            <td>${i.hits }</td>
                            <td>${i.hasFile }</td>
                            <td>${i.createDate }</td>
                        </tr> 
                   	</c:forEach>
                   
				</tbody>
			</table>
		</div>
	<!-- /TABLE -->



	<!-- PAGING  -->
		<div class="row text-center">
		    <div class="col-md-12">
			    <ul class="pagination pagination-simple pagination-sm">
				    <c:if test='${page > blockSize}'> <!-- 현페이지 > 보여줄사이즈 -->
				        <li class="page-item">
				        	<a class="page-link" href="javascript:movePage(null, '/board/list.do?page=${startBlockNo-blockSize}')">&laquo;</a>
				        </li>
				   	</c:if>
				   	
			        <c:forEach begin="${startBlockNo}" end="${endBlockNo}" step="1" var="p" >
			        	<c:choose>
			        		<c:when test="${page eq p}">
				        		<li class="page-item active"><a class="page-link">${p}</a></li>
			        		</c:when>
			        		<c:otherwise>
			        			<li class="page-item"><a class="page-link" 
			        			href="javascript:movePage(null, '/board/list.do', {page:'${p}', searchText:'${searchText}', searchType:'${searchType}'})">${p}</a></li>
			        			<!-- href="javascript:movePage(null, '/board/list.do?page=${p}&searchType=${searchType }&searchText=${searchText }')">${p}</a></li>  -->
			        			
			        		</c:otherwise>
			        	</c:choose>
			        	
			        </c:forEach>
			        <c:if test='${totalPage != endBlockNo}'>
				        <li class="page-item">
				        	<a class="page-link" href="javascript:movePage(null, '/board/list.do?page=${endBlockNo+1}')">&raquo;</a></li>
				        </li>
			        </c:if>
			    </ul>
		    </div>
		</div>
	<!-- /PAGING  -->	
		
		
		<c:if test='${sessionScope.memberId != null }'>
			<div class="row">
			    <div class="col-md-12 text-right">
			   
			    <a href="javascript:movePage(null, '/board/goToWrite.do')">
			        <button type="button" class="btn btn-primary">
			        	<i class="fa fa-pencil"></i> 글쓰기
			        </button>
			    </a>
			    </div>
			</div>
		</c:if>
	</div>
</section>
<!-- / -->
</body>
</html>