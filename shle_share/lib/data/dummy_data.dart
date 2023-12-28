import 'package:shle_share/models/bookLib.dart';
import 'package:shle_share/widget/post.dart';

final BookList = [
  BookLibrary(BookName: 'Fire and Blood', isFin: false, isReq: true),
  BookLibrary(BookName: 'Harry Potter', isFin: true, isReq: false),
  BookLibrary(BookName: 'The Great Gatsby', isFin: true, isReq: false),
  BookLibrary(BookName: 'Don Quixote', isFin: false, isReq: true),
  BookLibrary(BookName: 'In Search of Lost Time', isFin: false, isReq: true),
  BookLibrary(BookName: 'A song of Ice and Fire', isFin: true, isReq: false)
];

final Posts = [
  Post(
    name: 'Osama',
    bookDtails: ['Fire and Blood', 'Gorge R.R Martin', '1/2/2016'],
    username: '@ozayed',
    exhangeText: "Please I want This Book so bad",
    userImgUrl:
        'https://i.pinimg.com/564x/74/04/54/74045452c48b83ccb393a763d3e20872.jpg',
    bookimgUrl:
        "https://m.media-amazon.com/images/I/91gGPOBL5wL._AC_UF1000,1000_QL80_.jpg",
    Date: 'date',
  ),
  Post(
    name: "Saleh",
    bookDtails: ['Harry Potter', 'J.K.Rowling', '20/2/2001'],
    username: '@iSelphiole',
    exhangeText: 'Hey, I\'m looking to exhange this book ',
    userImgUrl:
        'https://static01.nyt.com/images/2022/10/24/arts/24taylor-notebook3/24taylor-notebook3-superJumbo.jpg',
    bookimgUrl:
        'https://m.media-amazon.com/images/I/81Fyh2mrw4L._AC_UF1000,1000_QL80_.jpg',
    Date: 'date',
  ),
];
