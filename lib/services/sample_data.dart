import '../models/recipe.dart';

const sampleRecipes = <Recipe>[
  Recipe(
    id: '1',
    name: 'Chocolate Brownies',
    thumbnail: '',
    category: 'Dessert',
    area: 'American',
    instructions:
        'Panaskan oven 180°C. Lelehkan cokelat dan mentega, campurkan dengan telur dan gula. Tambahkan tepung, tuang ke loyang, panggang 25 menit.',
    ingredients: ['200 g Dark chocolate', '150 g Butter', '3 Eggs', '120 g Sugar', '80 g Flour'],
  ),
  Recipe(
    id: '2',
    name: 'Apple Pie',
    thumbnail: '',
    category: 'Dessert',
    area: 'British',
    instructions:
        'Buat adonan kulit pie, isi dengan apel berbumbu kayu manis, tutup, lalu panggang 45 menit sampai keemasan.',
    ingredients: ['500 g Apples', '250 g Flour', '125 g Butter', '1 tsp Cinnamon', '80 g Sugar'],
  ),
  Recipe(
    id: '3',
    name: 'Banana Bread',
    thumbnail: '',
    category: 'Dessert',
    area: 'American',
    instructions:
        'Hancurkan pisang, campur dengan bahan lain, tuang ke loyang, panggang 55 menit.',
    ingredients: ['3 Bananas', '200 g Flour', '100 g Sugar', '2 Eggs', '80 g Butter'],
  ),
  Recipe(
    id: '4',
    name: 'Choc Chip Cookies',
    thumbnail: '',
    category: 'Dessert',
    area: 'American',
    instructions:
        'Kocok mentega dan gula, tambahkan telur dan tepung, masukkan choc chip, panggang 12 menit.',
    ingredients: ['120 g Butter', '100 g Brown sugar', '1 Egg', '180 g Flour', '100 g Chocolate chips'],
  ),
];