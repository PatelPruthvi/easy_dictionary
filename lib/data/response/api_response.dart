// ignore: constant_identifier_names
enum Status { ERROR, LOADING, COMPLETED }

class ApiResponse<T> {
  Status? status;
  T? data;
  String? msg;

  ApiResponse(this.msg, this.status, this.data);
  ApiResponse.loading() : status = Status.LOADING;
  ApiResponse.error(this.msg) : status = Status.ERROR;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  @override
  String toString() {
    return "Status : $status \n Message : $msg \n data : $data";
  }
}
