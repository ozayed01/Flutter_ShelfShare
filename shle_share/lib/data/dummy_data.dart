import 'package:shle_share/widget/book_view.dart';
import 'package:shle_share/widget/post.dart';

const BookList = [
  BookView(
    id: '1',
    title: 'Fire and Blood',
    bookImg:
        'https://m.media-amazon.com/images/I/91gGPOBL5wL._AC_UF1000,1000_QL80_.jpg',
    isFin: false,
    isReq: true,
  ),
  BookView(
    id: '2',
    title: 'Harry Potter',
    bookImg:
        'https://m.media-amazon.com/images/I/81Fyh2mrw4L._AC_UF1000,1000_QL80_.jpg',
    isReq: true,
    isFin: false,
  ),
  BookView(
    id: '3',
    title: 'The Great Gatsby',
    bookImg:
        'https://upload.wikimedia.org/wikipedia/commons/7/7a/The_Great_Gatsby_Cover_1925_Retouched.jpg',
    isReq: true,
    isFin: false,
  ),
  BookView(
    id: '4',
    title: 'Moby-Dick',
    bookImg:
        'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTfON1cFmFENLUz693WqLIqJZsNxVcs9uT0f8GDhnFnOv8AccGp',
    isReq: false,
    isFin: true,
  ),
  BookView(
    id: '5',
    title: 'Don Quixote',
    bookImg:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7uz0DNYz9a05dFiBvgvNYJ4GmV6cbjxUWUSWJrMcxqyAOlp5v',
    isReq: true,
    isFin: false,
  ),
  BookView(
    id: '6',
    title: 'In Search of Lost Time',
    bookImg: 'https://m.media-amazon.com/images/I/51tRkYYlpaL.jpg',
    isReq: false,
    isFin: true,
  ),
];

const Posts = [
  Post(
    name: 'Osama',
    bookDtails: ['Fire and Blood', 'Gorge R.R Martin', '1/2/2016'],
    username: '@ozayed',
    exhangeText: "Please I want This Book so bad",
    userImgUrl:
        'https://i.pinimg.com/564x/74/04/54/74045452c48b83ccb393a763d3e20872.jpg',
    bookimgUrl:
        "https://m.media-amazon.com/images/I/91gGPOBL5wL._AC_UF1000,1000_QL80_.jpg",
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
  ),
];
