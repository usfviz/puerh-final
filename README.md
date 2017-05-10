# project-prototype: World Food Facts Visualization
| Names          | Email                    |
| ---------------|:------------------------:|
| Elise Song     |nsong4@usfca.edu          |
| Kyle Kovecevich|kkovacevich@dons.usfca.edu|

# Discussion

This prototype contains all four of the visulizations we had aimed to include, namely:
- A word cloud created from the names of products
- A scatterplot matrix for numeric variables
- A parallel coordinates plot to allow for visual comparison of variables
- A radar chart overlaying the average nutritional contents of items from different countries

## Description of Dataset

Our data comes from "Open Food Facts", a database of nutrition and other attributes of food products sold in stores around the world. Our dataset is available on Kaggle: https://www.kaggle.com/openfoodfacts/world-food-facts. The entries are contributed by users, and many are missing some values, so cleaning was necessary. The data set provided in this directory is a subset of the original Kaggle data set; we decided to visualize five specific categories of food — cheese, processed meat, biscuits and cakes, soups, and alcoholic beverages — and to focus on least sparse columns about macronutrients (Fat, Carbs, Protein, Energy). 

## Interface
![alt text](https://github.com/usfviz/puerh-/blob/master/project-prototype/interface.png)
The categories of food selected by the user with the group input filter below the header panel are applied to all four plots. If the user deselects all categories, the food category filter resets back to the default choice "Cheese". 

## Prototypes
### Word Cloud
![alt text](https://github.com/usfviz/puerh-/blob/master/project-prototype/word.png)
After subsetting observations selected by the user, our app cleans the text in the product name column, and displays the most common words in the product names. The user can select the number of words to display, filter the data by one or more countries, as well as choose from four color palettes; the defaults are 100 words, USA, and Pink. 

### Scatterplot Matrix
![alt text](https://github.com/usfviz/puerh-/blob/master/project-prototype/scatter.png)
Our scatterplot matrix displays correlations between these numeric variables: "Energy", "Fat", "Saturated Fat", "Carbohydrates", "Proteins", "Sodium". The user can filter the data by countries.

### Parallel Coordinates Plot
![alt text](https://github.com/usfviz/puerh-/blob/master/project-prototype/parallel.png)
For the parallel coordinates plot we used the same numeric variables as the scatterplot matrix. Since each line represents one observation and displaying all of our data makes the plot overly clustered, we added a slider bar for the user to choose a sample size between 0.1 and 1. The user can filter the data by countries.

### Radar Plot
![alt text](https://github.com/usfviz/puerh-/blob/master/project-prototype/radar.png)
For the radar plot, we used a standard scale where the maximum for each variable is set at 1. If the user deselects enough countries that the number of countries selected is smaller than three, the country filter selection updates to "France", "USA", and "UK". 
