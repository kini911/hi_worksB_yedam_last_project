<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<title>Insert title here</title>
<style>
body {
	margin: 0 auto;
	font-size: small;
}

.body {
	width: 800px;
	margin: 0 auto;
}

.top {
	margin-bottom: 80px;
}

.table {
	width: 800px;
}

.table__title{
	font-size: small;
	text-align: left;
	height: 40px;
}

.main__p {
	font-size: larger;
	font-weight: bolder;
}

div h2 {
	margin-top: 51px;
	text-align: center;
}

.content {
	float: left;
	width: 800px;
	padding: 2px;
	border-bottom: 1px solid rgb(174, 213, 245);
	border-top: 1px solid rgb(174, 213, 245);
	
}

.buttonss {
	width: 800px;
	height: 50px;
	border-bottom: 1px solid rgb(174, 213, 245);
}

.button1 {
	float: left;
	margin-top: 5px;
	color: black;
}

.buttons {
	float: right;
	width: 103px;
	margin-top: 5px;
}

.buttons :first-child {
	float: left;
	margin-right: 3px;
}

.buttonss__button {
	background-color: rgb(174, 213, 245);
    border-radius: 5px;
    color: white;
    width: 50px;
    height: 30px;
    font-weight: bold;
}

.table__title :first-child {
	display: inline-block;
	line-height: 26px;
	width: 40px;
	height: 25px;
	text-align: center;
	background: rgb(174, 213, 245);
	border: 1px solid rgb(174, 213, 245);
	border-radius: 5px;
	
}

.table__title :last-child {
	border: 1px solid rgb(174, 213, 245);
	border-radius: 3px;
	width: 757px;
	height: 25px;
}

	.ck.ck-editor {
    	width: 817px;
    	margin: 0 auto;
    	board: 0;
	}
	.ck-editor__editable {
		margin: 0 auto;
	    min-height: 300px;
	    width: 800px;
	}

</style>
</head>
<body>
<script src="https://cdn.ckeditor.com/ckeditor5/34.0.0/classic/ckeditor.js"></script>		
<script src="https://ckeditor.com/apps/ckfinder/3.5.0/ckfinder.js"></script>
	<div class="top">
		<h2>카풀 게시판 작성</h2>
	</div>
	<div class="body">
		<form action="carpoolInsert" method="post">
			<table class="table">
				<thead>
					<tr class="main__p">
						<th class="table__title">
							<label id="boardTitle">제목 </label>
							<input type="text" name="boardTitle">
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<div class="content">
								<textarea name="noticeContent" id="editor"></textarea>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<label id="departure">출발</label>
							<input type="text" name="departure"><br>
							<label id="arrival">도착</label>
							<input type="text" name="arrival"><br>
							<label id="departureDate">날짜</label>
							<input type="text" name="departureDate"><br>
							<label id="passenger">인원</label>
							<input type="number" name="passenger">
						</td>
					</tr>
					<tr>
						<td>
							<input type="hidden" name="memberId" value="${memberInfo.memberId }">
							<input type="hidden" name="companyId" value="${memberInfo.companyId}">
							<input type="hidden" name="category" value="B1">
						</td>
					</tr>
				</tbody>
			</table>
			<button type="button" onclick="location.href='carpoolList'">목록</button>
			<button type="submit">작성</button>
		</form>
	</div>
	<!-- 지도  -->
	<div id="map" style="width:500px;height:400px;"></div>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d2a237b360646754fd5f20a66df56e27"></script>
</body>
<script>
	$(document).ready(function(){
    $('input.timepicker').timepicker({});
});
	
	ClassicEditor.create( document.querySelector( '#editor' ), {
	    ckfinder:{
	    	uploadUrl: '${pageContext.request.contextPath}/ckuploadsAjax'
	    },
	 
	    /* 폰트 설정 안됨. 죽이고싶음 */
	    fontFamily:{
	    	items:[
	    		'default',
	    		'Arial',
	    		'궁서체',
	    		'바탕',
	    		'돋움'
	    	],
	    	supportAllValues: true
	    }
	  }
	  
	);
</script>
</html>