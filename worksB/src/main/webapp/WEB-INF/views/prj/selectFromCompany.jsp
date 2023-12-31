<!-- A1은 YEs A2는 NO -->


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.list-title {
	font-size: var(--font-regular);
	padding: 0 30px;
	margin-bottom: 15px;
	color: var(--color-dark-grey);
}

.list-box {
	width: 70%;
	margin: 0 auto;	
	font-size: 18px; 
	font-weight: var(--weight-semi-bold);
}

.list {
	padding: 10px 40px;
	margin: 5px 0;
	border-radius: 5px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	background-color: rgb(253, 252, 220, 0.2);
}

.list-option {
	display: flex;
	align-items: center;
	margin: 20px 0 30px;
	justify-content: space-between;
}

.list-option select {
	width: 100px;
	height: 30px;
	border-radius: 4px;
  	border: 1px solid var(--color-dark-beigie);
  	outline: none;
}

.list-option select:focus{
	outline: none;
}

.project-name {
	margin-right: 50px;
	height: 30px;
	line-height: 30px;
	display: flex;
	align-items: center;
}

.project-info {
	display: flex;
	align-items: center;
	margin-right: 80px;
}

.dept-list {
	display: flex;
	justify-content: flex-start;
	font-size: 16px; 
	color: var(--color-light-grey);
}

.list-count {
	font-size: var(--font-small); 
	font-weight: var(--weight-bold);
}

.list-count span {
	color: var(--color-red);
	margin-left: 5px;
}

.dept-list li {
	padding: 7px 10px;
	border-radius: 10px;
	margin-right: 10px;
	cursor: pointer;
	border: 1px solid rgba(174, 213, 245, 0);
}

.dept-list li:hover {
	border: 1px solid var(--color-dark-beigie);
	background-color: var(--color-dark-beigie);
	color: var(--color-dark-red);	
}

.icon {
	width : 30px;
	height : 30px;
}

.prj-icon {
	margin: 0 10px;
	display: inline-block;
}

.list-btn {
	width: 70px;
	height: 34px;
	border-radius: 17px;
	color: white;
	cursor: default;
}
.point {
	cursor: pointer;
}
.green {
	background-color: #29bf12;
}

.yellow {
	background-color: var(--color-orange);
}

.red {
	background-color: var(--color-red);
}


</style>
</head>

<body>
    <form name="deptInfo" action="${pageContext.request.contextPath }/SelectFromCompany">
    	<input type="hidden" name="deptId" value="${projectVO.deptId }">
    	<input type="hidden" name="projectCls" value="${projectVO.projectCls }">
    </form>
	<h3 class="list-title">회사 전체 프로젝트</h3>
	<div style="padding: 5px 50px;">
		<ul class="dept-list">
			<li class="view-dept" onclick="viewPart('')">전체보기</li>
			<c:forEach items="${deptList }" var="dept">
				<li class="view-dept" onclick="viewPart('${dept.deptId}')" data-id="${dept.deptId }">${dept.deptName }</li>
			</c:forEach>
		</ul>
	</div>
	<div class="list-box">
		<div class="list-option">
			<div class="list-count">전체 <span>${projectList.size() }</span></div>
			<div>
				<select class="option">
					<option value="A2" selected>진행중</option>
					<option value="A1">만료</option>
				</select>
			</div>
		</div>
		<!-- 프로젝트리스트 전체(particirAccp가 Y,N,null로 나뉨) -->
		<c:forEach items="${projectList }" var="list">
			<div class="list">
				<!-- 회사전체공개프로젝트의 경우 -->

					<div class="project-name">
					
						<c:if test="${list.projectAccess eq 'YES' }">
							<img class="prj-icon" alt="전체공개이미지" title="전체공개" src="${pageContext.request.contextPath }/resources/icon/globe-solid.svg">
						</c:if>
						<c:if test="${list.projectAccess eq 'NO' }">
							<img class="prj-icon" alt="참여자공개이미지" title="참여자만 공개" src="${pageContext.request.contextPath }/resources/icon/lock-solid.svg">	
						</c:if>
						
						<span class="prj-move" data-cls="${list.projectCls }" data-access="${list.projectAccess}" data-accp="${list.particirAccp}" data-prjid="${list.projectId }">${list.projectName}</span>  

					</div>
					
					<!-- 참여버튼 클릭 시 참여하기 기능 구현  필요함 -->
					<div class="project-info">
						${list.prjParticirNum }<img class="prj-icon" alt="참가인원" title="참가인원" src="${pageContext.request.contextPath }/resources/icon/user-solid.svg">
						<c:if test="${list.projectCls eq 'NO' }">						
							<!-- particirAccp(승인여부)Y -->
							<c:if test="${list.particirAccp eq 'YES' }">
								<button type="button" class="list-btn red">참여중</button>  
							</c:if>
							<!-- particirAccp(승인여부)N -->
							<c:if test="${list.particirAccp eq 'NO' }">
								<button type="button" class="list-btn yellow">승인대기</button>
							</c:if>
							<!-- particirAccp(승인여부)null(승인신청을 하지 않았다는 의미) -->
							<c:if test="${list.particirAccp eq null }">
								<button type="button" class="list-btn green point">참여하기</button>
							</c:if>
						</c:if>
					</div>
			</div>
		</c:forEach>
	</div>
</body>
<script>
	//프로젝트div클릭시 피드로 이동
	$('.prj-move').on('click',(e=>{
		let access=$(e.target).data("access")
		let accp=$(e.target).data("accp")
		let id=$(e.target).data("prjid")
		let cls=$(e.target).data("cls")
		//만료여부에 따른 분기
		if(cls=='NO'){
			//공개여부(전체공개)		비공개이지만 승인받은 경우
			if(access=='YES' || ( access=='NO' && accp=='YES')) {
				location.href='${pageContext.request.contextPath }/projectFeed?projectId='+id
			}
		}else if(cls=='YES'){
			
		}
		
		
	}))
	//부서정보를 컨트롤러에 넘김
	function viewPart(dept){
		deptInfo.deptId.value=dept;
		deptInfo.submit();
	}
	
	//select에 따른 데이터변동
	$('.option').change(function() {
		deptInfo.projectCls.value=$('.option').val()
		deptInfo.submit();	
	})
	//페이지가 바뀌어도 selectBox가 변동되지 않도록 하기 위함	
	if("${projectVO.projectCls }"!=""){
		$('.option').val("${projectVO.projectCls }")		
	}

	
</script>
</html>