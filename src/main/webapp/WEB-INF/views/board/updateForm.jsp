<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<script type="text/javascript">
$(document).ready(function() {

	$("#hiBbsTitle").focus();
	
	$("#btnUpdate").on("click", function() {
		
		$("#btnUpdate").prop("disabled", true);		//버튼 비활성화
		
		if($.trim($("#hiBbsTitle").val()).length <= 0)
		{
			alert("제목을 입력하세요.");
			$("#hiBbsTitle").val("");
			$("#hiBbsTitle").focus();
			return;
		}

		if($.trim($("#hiBbsContent").val()).length <= 0)
		{
			alert("내용을 입력하세요.");
			$("#hiBbsContent").val("");
			$("#hiBbsContent").focus();
			return;
		}
		
		var form = $("#updateForm")[0];
		var formData = new FormData(form);
		
		$.ajax({
			type:"POST",
			enctype:"multipart/form-data",
			url:"/board/updateProc",
			data:formData,
			processData:false,
			contentType:false,
			cache:false,
			beforeSend:function(xhr)
			{
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response)
			{
				if(response.code == 0)
				{
					alert("게시물이 수정 되었습니다.");
					location.href = "/board/list";
					/*
					document.bbsForm.action = "/board/list";
					document.bbsForm.submit();
					*/
				}
				else if(response.code == 400)
				{
					alert("파라미터 값이 올바르지 않습니다.");
					$("#btnUpdate").prop("disabled", false);		//버튼 활성화
				}
				else if(response.code == 403)
				{
					alert("본인 게시물이 아닙니다.");
					$("#btnUpdate").prop("disabled", false);		//버튼 활성화
				}
				else if(response.code == 404)
				{
					alert("게시물을 찾을수 없습니다.");
					location.href = "/board/list";
				}
				else
				{
					alert("게시물 수정 중 오류가 발생하였습니다.");
					$("#btnUpdate").prop("disabled", false);		//버튼 활성화
				}
			},
			error:function(error)
			{
				icia.common.error(error);
				alert("게시물 수정 중 오류가 발생하였습니다.");
				$("#btnUpdate").prop("disabled", false);		//버튼 활성화
			}
		});
	});
	
	$("#btnList").on("click", function() {
		document.bbsForm.action = "/board/list";
		document.bbsForm.submit();
	});


});
</script>
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="container">
	<h2>게시물 수정</h2>
	<form name="updateForm" id="updateForm" method="post" enctype="multipart/form-data">
		<input type="text" name="userName" id="userName" maxlength="20" value="${user.userName}" style="ime-mode:active;" class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly />
		<input type="text" name="userEmail" id="userEmail" maxlength="30" value="${user.userEmail}"  style="ime-mode:inactive;" class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly />
		<input type="text" name="hiBbsTitle" id="hiBbsTitle" maxlength="100" style="ime-mode:active;" value="${hiBoard.hiBbsTitle}" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
		<div class="form-group">
			<textarea class="form-control" rows="10" name="hiBbsContent" id="hiBbsContent" style="ime-mode:active;" placeholder="내용을 입력해주세요" required>${hiBoard.hiBbsContent}</textarea>
		</div>
		<input type="file" name="hiBbsFile" id="hiBbsFile" class="form-control mb-2" placeholder="파일을 선택하세요." required />
<c:if test="${!empty hiBoard.hiBoardFile}">
		<div style="margin-bottom:0.3em;">[첨부파일 : ${hiBoard.hiBoardFile.fileOrgName}]</div>
</c:if>
		<input type="hidden" name="hiBbsSeq" value="${hiBoard.hiBbsSeq}" />
		<input type="hidden" name="searchType" value="${searchType}" />
		<input type="hidden" name="searchValue" value="${searchValue}" />
		<input type="hidden" name="curPage" value="${curPage}" />
	</form>
	
	<div class="form-group row">
		<div class="col-sm-12">
			<button type="button" id="btnUpdate" class="btn btn-primary" title="수정">수정</button>
			<button type="button" id="btnList" class="btn btn-secondary" title="리스트">리스트</button>
		</div>
	</div>
</div>
<form name="bbsForm" id="bbsForm" method="post">
	<input type="hidden" name="hiBbsSeq" value="${hiBoard.hiBbsSeq}" />
	<input type="hidden" name="searchType" value="${searchType}" />
	<input type="hidden" name="searchValue" value="${searchValue}" />
	<input type="hidden" name="curPage" value="${curPage}" />
</form>

</body>
</html>