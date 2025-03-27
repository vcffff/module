void main(){
  Map<String, int> students = {
    'Айбек': 95,
    'Жанна': 88,
    'Марат': 92,
    'Камила': 76,
    'Сергей': 99,
  };
  List hello=[];
  students.forEach((key,value){
    if(value>=90){
      hello.add(key);
    }

  });
  print(hello);
}