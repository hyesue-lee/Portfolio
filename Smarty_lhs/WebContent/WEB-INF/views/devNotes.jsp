<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
</head>

	<body class="smoothscroll enable-animation">

			
			<%-- 내용 나올 div 시작!!!! --%>
			<section class="alternate">
				<div class="container" align="center">

					<div class="row">

						<div class="col-md-4">

							<div class="box-icon box-icon-center box-icon-round box-icon-transparent box-icon-large box-icon-content" align="center">
								<div class="box-icon-title">
									<i class="b-0 fa fa-database"></i>
									<h2>ERD</h2>
								</div>
								
<a data-toggle="modal" data-target="#modalERD" style="width:90%; opacity:0.5;margin-bottom:40px" 
class="btn btn-featured btn-inverse btn-round btn-default">
	<span>DB Modeling</span>
	<i class="fa fa-eye"></i>
</a>

<a href="<c:url value='/file/downloadERD.do'/>" style="width:90%; opacity:0.5;" 
class="btn btn-featured btn-inverse btn-round btn-default">
	<span>Download MWB</span>
	<i class="fa fa-download"></i>
</a>

							</div>

						</div>

						<div class="col-md-4">

							<div class="box-icon box-icon-center box-icon-round box-icon-transparent box-icon-large box-icon-content">
								<div class="box-icon-title">
									<i class="b-0 fa fa-file-code-o"></i>
									<h2 style="margin-bottom:10px">Today I Learned.</h2>
								</div>
								<div class="box-icon-content">
								
								<a href="http://cheershennah.tistory.com" target="_blank" opacity="0.8"
								onmouseover="this.style.opacity='0.2'" 
								onmouseout="this.style.opacity='0.8'" >
								<img src="<c:url value='/resources/images/tistory.png'/>" style="width:20%;margin-bottom:10px"/>
										
								</a><p style="font-size:13px; margin:0 0 15px 0;">기록이 모여 기술이 됩니다.</p>	
						
								
								<a href="https://github.com/hyesue-lee" target="_blank"
								onmouseover="this.style.opacity='0.2'" 
								onmouseout="this.style.opacity='1'">
								<img src="<c:url value='/resources/images/github.png'/>" style="width:25%;"/>						
								</a>
								<p style="font-size:13px; margin:0;">새로운 기술을 끊임없이 탐구합니다.</p>	
								</div>
								
							</div>

						</div>

						<div class="col-md-4">

							<div class="box-icon box-icon-center box-icon-round box-icon-transparent box-icon-large box-icon-content">
								<div class="box-icon-title">
									<i class="b-0 fa fa-cogs"></i>
									<h2>Development Tools</h2>
								</div>
								
								<div style="padding-bottom:20px">
								<a data-toggle="modal" data-target="#modalDevTool">
								<img src="<c:url value='/resources/images/dev-tools.png'/>" style="width:80%; opacity:0.7;"
								onmouseover="this.style.opacity='1'" 
								onmouseout="this.style.opacity='0.7'" />
														
								</a>
								</div>
							</div>

						</div>

					</div>


				</div>
				
				
					<!-- ERD modal content -->
					<div id="modalERD" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
						<div class="modal-dialog modal-lg">
							<div class="modal-content">

								<!-- Modal Header -->
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
									<h4 class="modal-title" id="myModalLabel">ERD</h4>
								</div>

								<!-- Modal Body -->
								<div class="modal-body">

									<img id="erdImg" width="100%" src="<c:url value='/resources/portfolio_ERD.png'/>"/>
								</div>
								<!-- Modal Footer -->
								<div class="modal-footer">
									<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
								</div>

							</div>
						</div>
					</div> 
					<!--/ERD modal content -->
					
					<!-- Tools modal content -->
					<div id="modalDevTool" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
						<div class="modal-dialog">
							<div class="modal-content">

								<!-- Modal Header -->
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
									<h4 class="modal-title" id="myModalLabel">Development Tools</h4>
								</div>

								<!-- Modal Body -->
								
								<div class="modal-body">
									
									<img id="toolImg" width="100%" src="<c:url value='/resources/images/dev-tools.png'/>"/>
									
									
								</div>
								<!-- Modal Footer -->
								<div class="modal-footer">
									<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
								</div>

							</div>
						</div>
					</div> 
					<!-- /Tools modal content -->

					
				</div>
				
				
			</section>
			<!-- / -->

	

		
	</body>
</html>