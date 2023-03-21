# Big Data ETL
<img src="Images\etl.jpg"/>
## Background
This is an assignment to to perform the ETL process completely in the cloud and upload a DataFrame to an RDS instance. And finally use PySpark or SQL to perform a statistical analysis of selected data.

## Darasets
* Amazon Customer Reviews Dataset. (n.d.). Retrieved April 08, 2021, from: https://s3.amazonaws.com/amazon-reviews-pds/readme.html.



* Amazon's [Vine reviews](https://www.amazon.com/vine/about?ie=UTF8) Dataset. Vine reviewers receive free products in exchange for reviews. https://www.amazon.com/vine/about?ie=UTF8.

Amazon products review datasets are quite large and can exceed the capacity of local machines. One dataset alone contains over 1.5 million rows; with over 40 datasets, data analysis can be very demanding on the average local computer. 

## ETL
The ETL process was done in two parts.
* **Part 1:** Extract two Amazon customer review datasets, transform each dataset into four DataFrames, and load the DataFrames into an RDS instance.

* **Part 2:** Statistical analysis of those datasets useing either SQL whether reviews from Amazon's Vine program are trustworthy.

### Part 1
The two datasets utilized in the analysis comprised of Amazon's baby review dataset and grocery review dataset.


#### Extract the Data
<img src="Images\extract.jpg"/>
1. Read in each dataset using the correct `header` and `sep` parameters.
<img width="1214" alt="Screenshot 2023-03-08 at 3 37 05 PM" src="https://user-images.githubusercontent.com/112406455/223857257-cef556ea-6045-4c9e-9b5f-5533f634a5d0.png">

2. Get the number of rows in the dataset.
<img width="1212" alt="Screenshot 2023-03-08 at 3 37 14 PM" src="https://user-images.githubusercontent.com/112406455/223857420-5d731410-93c6-4efc-8b52-7fd00ccabcaf.png">

#### Transform the Data
<img src="Images\t.jpeg"/>

A 'schema.sql' file was created for each dataset to produce four SQL database tables.

1. Create the "review_id_df" DataFrame with the appropriate columns and data types.
<img width="1214" alt="Screenshot 2023-03-08 at 3 37 30 PM" src="https://user-images.githubusercontent.com/112406455/223857603-dc27d507-86f9-4872-ae61-16f0423f2b7f.png">

2. Create the "products_df" DataFrame that drops the duplicates in the "product_id" and "product_title columns.
<img width="1212" alt="Screenshot 2023-03-08 at 3 37 38 PM" src="https://user-images.githubusercontent.com/112406455/223857797-d0cb5c5f-0313-401b-acb9-b2f06dd38794.png">

3. Create the "customers_df" DataFrame that groups the data on the "customer_id" by the number of times a customer reviewed a product.
<img width="1214" alt="Screenshot 2023-03-08 at 3 37 48 PM" src="https://user-images.githubusercontent.com/112406455/223857913-e77540c9-81da-48f2-8c8e-0ddf48598b36.png">

4. Create the "vine_df" DataFrame that has the "review_id", "star_rating", "helpful_votes", "total_votes", and "vine" columns.
<img width="1212" alt="Screenshot 2023-03-08 at 3 37 57 PM" src="https://user-images.githubusercontent.com/112406455/223858022-916aefd7-ce08-41cd-8d91-8538e07a24ec.png">

#### Load the Data into an RDS Instance
<img src="Images\load.jpeg"/>

Export each DataFrame into the RDS instance to create four tables for each dataset.
<img width="1213" alt="Screenshot 2023-03-08 at 3 38 45 PM" src="https://user-images.githubusercontent.com/112406455/223858179-19e2b186-ae25-4d86-b8ed-ff84f6d79ccd.png">

### Part 2 

### SQL Queries Employed in Data Analysis
#### Product Analysis
```sql
SELECT p.product_id, p.product_title, COUNT(*) AS review_count 
FROM review_id_table r 
JOIN products p ON r.product_id = p.product_id 
GROUP BY p.product_id, p.product_title 
ORDER BY review_count DESC 
LIMIT 10;

SELECT r.product_id, AVG(v.star_rating) AS avg_rating, p.product_title
FROM review_id_table r 
JOIN vine_table v ON r.review_id = v.review_id 
JOIN products p ON r.product_id = p.product_id
GROUP BY r.product_id, p.product_title
ORDER BY avg_rating DESC 
LIMIT 10;

SELECT r.product_id, 
    AVG(helpful_votes) AS avg_helpful_votes, 
    AVG(total_votes) AS avg_total_votes,
    p.product_title
FROM review_id_table r
JOIN vine_table v ON r.review_id = v.review_id
JOIN products p ON r.product_id = p.product_id
GROUP BY r.product_id, p.product_title
ORDER BY avg_total_votes DESC;

SELECT r.product_id, p.product_title,
    AVG(helpful_votes) AS avg_helpful_votes
FROM review_id_table r
JOIN vine_table v ON r.review_id = v.review_id
JOIN products p ON r.product_id = p.product_id
GROUP BY r.product_id, p.product_title
ORDER BY avg_helpful_votes DESC 
LIMIT 10;
```
Vine Analysis
```sql
SELECT COUNT(*) FROM review_id_table;

SELECT COUNT(*) FROM vine_table WHERE vine = 'Y';

SELECT COUNT(*) FROM vine_table WHERE vine = 'N';

SELECT AVG(star_rating) FROM vine_table WHERE vine = 'Y';

SELECT AVG(star_rating) FROM vine_table WHERE vine = 'N';

SELECT star_rating, COUNT(*) FROM vine_table WHERE vine = 'Y' GROUP BY star_rating;

SELECT star_rating, COUNT(*) FROM vine_table WHERE vine = 'N' GROUP BY star_rating;

SELECT AVG(helpful_votes) FROM vine_table WHERE vine = 'Y';

SELECT AVG(helpful_votes) FROM vine_table WHERE vine = 'N';

SELECT AVG(total_votes) FROM vine_table WHERE vine = 'Y';
```
* Submit a summary of your findings and analysis.
## Summary
### Analysis of Amazon Baby Product Reviews Dataset
#### Product Analysis 
Top 10 products with the highest number of reviews:
* Baby Einstein Take Along Tunes Musical Toy
* Infant Optics DXR-5 Portable Video Baby Monitor
* Vulli Sophie la Girafe
* FridaBaby NoseFrida The SnotSucker Nasal Aspirator
* Regalo Easy Step Walk Thru Gate, White, Fits Spaces between 29" and 39" Wide
* Graco Nautilus 3-in-1 Car Seat
* Baby Banana Toothbrush
* Summer Infant Multi-Use Deco Extra Tall Walk-Thru Gate, Bronze
* VTech Communications Safe andSound Digital Audio Monitor
* Munchkin Nursery Projector and Sound System, White

Top 10 products with the highest average star rating for Vine reviews:
* Countdown to a Miracle: Daily Pregnancy Calendar
* Baby's First Journal - Green
* Record Books Baby's First Year Memory Keeper
* Gruffalos Child Sitting 7 Inch Soft Toy
* Nature's Lullabies First and Second Year Calendars
* John Lennon Real Love Slipcase 3 Baby Photo Album Set
* God Bless Baby Record Book: A Record Book of Special Memories (Baby Love Bears & Friends)
* 5 Pink Gumdrops + One Pacifier Clip
* Lifefactory 4oz BPA Free Glass Baby Bottles - 4-pack-raspberry and Lilac
* The Letterheads - Make It Better With A Letter! Kids place mat

Top 10 products with the highest average total votes for Vine reviews:
* Carter's Bound Keepsake Memory Book of Baby's First 5 Years
* The Stork OTC Conception Aid
* Vulli Sophie The Giraffe Teether
* Stork Craft Long Horn Bunk Bed
* Breathable Safer Bumper for Slatted Cribs in White
* Wash Pod
* Simple Wishes Hands Free Pumping Bustier/Bra XS/S/M
* BABYBJORN Smart Potty
* Dorel Living Baby Relax Mikayla Upholstered Swivel Gliding Recliner
* DaVinci Emily Mini Crib

Top 10 products with the highest average helpful votes:
* Carter's Bound Keepsake Memory Book of Baby's First 5 Years
* The Stork OTC Conception Aid
* Stork Craft Long Horn Bunk Bed
* Vulli Sophie The Giraffe Teether
* Breathable Safer Bumper for Slatted Cribs in White
* Simple Wishes Hands Free Pumping Bustier/Bra XS/S/M
* DaVinci Emily Mini Crib
* Philips Sweet Dreams Cradle Player
* BABYBJORN Smart Potty
* Dorel Living Baby Relax Mikayla Upholstered Swivel Gliding Recliner

#### Vine Analysis
Based on the data extracted from the queries, it can be concluded that Vine reviews are not entirely free of bias. The total number of reviews is 1,752,932, out of which only 1,2100 reviews are from the Vine program, and 1,740,832 are not from the Vine program. This indicates a significant disparity in the number of reviews between the two programs.

The average star rating for Vine reviews is 4.29, which is slightly higher than the average star rating for non-Vine reviews, which is 4.16. This indicates that Vine reviews may be biased towards higher ratings. Additionally, the distribution of star ratings for Vine reviews is significantly different from the distribution of star ratings for non-Vine reviews. For example, Vine reviews have a higher proportion of five-star ratings (50.2%) than non-Vine reviews (38.5%).

Furthermore, Vine reviews tend to have more helpful votes and total votes than non-Vine reviews. The average number of helpful votes per Vine review is 3.66, which is significantly higher than the average number of helpful votes per non-Vine review (1.61). The average number of total votes per Vine review is also higher than the average number of total votes per non-Vine review (4.56 vs. 1.61). This suggests that Vine reviews may be more visible and accessible than non-Vine reviews.

Overall, the analysis indicates that Vine reviews may be biased towards higher ratings and may receive more visibility and attention than non-Vine reviews. However, the analysis is limited to the available data and does not account for other factors that may affect the review process, such as the quality of the product, the reviewer's background, or the review platform's policies and procedures. Therefore, further research is needed to provide a more comprehensive understanding of the biases and limitations of the Vine review program.
### Analysis of Amazon Grocery Product Reviews Dataset
#### Product Analysis
Top 10 products with the highest number of reviews:
* Viva Naturals Organic Extra Virgin Coconut Oil, 16 Ounce
* San Francisco Bay One Cup
* Surge Citrus Flavored Soda 16fl oz. 12 cans
* San Francisco Bay One Cup
* Keurig, The Original Donut Shop, K-Cup packs
* Ekobrew Coffee Reusable Filter, Small, Violet
* Brooklyn Beans Single-cup Coffee for Keurig K-Cup Brewers, 40-Count
* Nutiva Organic Virgin Coconut Oil, 15 Ounce
* San Francisco Bay One Cup
* Grove Square Cappuccino, Single Serve Cup for Keurig K-Cup Brewers

Top 10 products with the highest average star rating for Vine reviews:
* Milky Way Magic Stars 117g
* Delgada coffee infused with Chaga 28 Sachets per box
* Apples Cut-Outs
* Axis and Allies 1942 Second Edition: A Wwii Strategy Game; Wizards of the Coast
* Beemster Gouda - Aged 18/24 Months - App. 1.5 Lbs
* Royal Manna Mix
* Pure Darjeeling Tea: Loose Leaf
* 100 Percent All Natural Vanilla Extract
* Archer Farms Strawberry Dragonfruit Drink Mix 8-0.16 Oz Packets
* Cadbury Bournville 100g

Top 10 products with the highest average total votes for Vine reviews:
* Bragg Organic Raw Apple Cider Vinegar
* Flora Flor-Essence
* Herbal Secrets Black Seed Oil Natural Dietary Supplement - Cold Pressed Black Cumin Seed Oil from 100% Genuine Nigella Sativa - 16 oz Bottle
* Gourmet Abundance Fruit Basket Gift
* Nature's Way Coconut Oil-extra Virgin
* Spartagen XT Advanced Testosterone Support  60 Capsules
* Blk Beverages Enriched with Fulvic Acid 16.9 oz Pack of 12
* Banza Chickpea Pasta
* Organo Gold Gourmet Black Coffee
* Emergency Reserve 90 Serving Breakfast, Lunch/Dinner Emergency Food Supply

Top 10 products with the highest average helpful votes:
* Bragg Organic Raw Apple Cider Vinegar
* Flora Flor-Essence
* Herbal Secrets Black Seed Oil Natural Dietary Supplement - Cold Pressed Black Cumin Seed Oil from 100% Genuine Nigella Sativa - 16 oz Bottle
* Gourmet Abundance Fruit Basket Gift
* Nature's Way Coconut Oil-extra Virgin
* Banza Chickpea Pasta
* Blk Beverages Enriched with Fulvic Acid 16.9 oz Pack of 12
* Organo Gold Gourmet Black Coffee
* Albanese Candy, Sugar Free Assorted Fruit Gummi Bears, 5-pound Bag
* Yogourmet Freeze Dried Kefir Starter, 1 Ounce Boxes (Pack of 2)
#### Vine Analysis
Based on the results of the queries, it appears that Vine reviews may not be free of bias.

Firstly, there are significantly fewer Vine reviews (16,612) compared to non-Vine reviews (2,385,819), which could indicate a selection bias in the types of products that are being reviewed.

Additionally, the average star rating for Vine reviews (3.91) is lower than the average star rating for non-Vine reviews (4.32). This suggests that Vine reviewers may be more critical or discerning in their reviews.

Furthermore, there is a difference in the distribution of star ratings between Vine and non-Vine reviews. Vine reviews tend to have a higher proportion of 4 and 5-star ratings, while non-Vine reviews tend to have a higher proportion of 1, 2, and 3-star ratings. This could indicate that Vine reviewers are more likely to give positive reviews.

Finally, the average number of helpful votes for Vine reviews (0.60) is much lower than the average for non-Vine reviews (1.55), which could indicate that Vine reviews are not as helpful or informative to other customers.

Overall, while these findings do not definitively prove bias in Vine reviews, they do suggest that there may be some differences between Vine and non-Vine reviews that warrant further investigation.
## File Organization and Structure
The project is structured as follows:
* `Resources` folder containing `schema.sql`, which outlines the schema for the database tables
* `part-1` folder containing the Jupyter Notebooks used for the ETL process, including `part_one_baby.ipynb` and `part_one_grocery.ipynb`
* `part-2` folder containing `product_queries.sql` and `vine_reviews.sql`, which contain SQL queries used for analyzing the data.
* `README.md` file with information on how to use the repository and any important details about the data and analysis. 