import pandas as pd

chunk_size = 2000
batch_no = 1

for chunk in pd.read_csv('BigBasket Products.csv',chunksize=chunk_size,encoding= 'unicode_escape'):
	chunk.to_csv('BigBasket Products' + str(batch_no) + '.csv', index=False)
	batch_no+=1