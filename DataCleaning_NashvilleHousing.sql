SELECT * FROM DataCleaning.nashvillehousing;

/* CLEANING DATA USING SQL: */
-------------------------------------------------------------------------------------------------------------
-- 1. Standardize Date Format:
SELECT SaleDate, STR_TO_DATE(SaleDate,"%M %D %Y") FROM DataCleaning.nashvillehousing order by 2;
UPDATE DataCleaning.nashvillehousing SET SaleDate= STR_TO_DATE(SaleDate,"%M %D %Y");
SELECT * FROM DataCleaning.nashvillehousing WHERE SaleDate not like '%-%-%';
-------------------------------------------------------------------------------------------------------------
-- 2. Populate Property Address Column:
SELECT distinct(ParcelID), PropertyAddress FROM DataCleaning.nashvillehousing WHERE PropertyAddress=''; 
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,COALESCE(NULLIF(a.PropertyAddress,''),b.PropertyAddress)
FROM DataCleaning.nashvillehousing a JOIN DataCleaning.nashvillehousing b
ON a.ParcelID=b.ParcelID AND a.UniqueID!=b.UniqueID
WHERE a.PropertyAddress= '';
UPDATE DataCleaning.nashvillehousing a
JOIN DataCleaning.nashvillehousing b
ON a.ParcelID=b.ParcelID AND a.UniqueID!=b.UniqueID
SET a.PropertyAddress = COALESCE(NULLIF(a.PropertyAddress,''),b.PropertyAddress)
WHERE a.PropertyAddress= '';
-------------------------------------------------------------------------------------------------------------
-- 3. Breaking out Address into individual columns(Address, City and State):
SELECT PropertyAddress FROM DataCleaning.nashvillehousing;
SELECT substring(PropertyAddress,1, LOCATE(',' , PropertyAddress)-1),
substring(PropertyAddress, locate(',',PropertyAddress)+1, length(PropertyAddress))
FROM DataCleaning.nashvillehousing;
ALTER TABLE DataCleaning.nashvillehousing
ADD PropertySplitAddress nvarchar(225);
ALTER TABLE DataCleaning.nashvillehousing
ADD PropertySplitCity nvarchar(225);
UPDATE DataCleaning.nashvillehousing
SET PropertySplitAddress= substring(PropertyAddress,1, LOCATE(',' , PropertyAddress)-1);
UPDATE DataCleaning.nashvillehousing
SET PropertySplitCity= substring(PropertyAddress, locate(',',PropertyAddress)+1, length(PropertyAddress));
SELECT PropertyAddress,PropertySplitAddress,PropertySplitCity FROM DataCleaning.nashvillehousing;

SELECT OwnerAddress FROM DataCleaning.nashvillehousing;
SELECT substring_index(OwnerAddress,',',1), substring_index(substring_index(OwnerAddress,',',2) ,',',-1),
substring_index(OwnerAddress,',',-1)
FROM DataCleaning.nashvillehousing;
ALTER TABLE DataCleaning.nashvillehousing
ADD OwnerSplitAddress varchar(255);
ALTER TABLE DataCleaning.nashvillehousing
ADD OwnerSplitCity varchar(255);
ALTER TABLE DataCleaning.nashvillehousing
ADD OwnerSplitState varchar(255);
UPDATE DataCleaning.nashvillehousing
SET OwnerSplitAddress=substring_index(OwnerAddress,',',1);
UPDATE DataCleaning.nashvillehousing
SET OwnerSplitCity=substring_index(substring_index(OwnerAddress,',',2) ,',',-1);
UPDATE DataCleaning.nashvillehousing
SET OwnerSplitState=substring_index(OwnerAddress,',',-1);
SELECT OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState FROM DataCleaning.nashvillehousing;
-------------------------------------------------------------------------------------------------------------
-- 4. Change Y and N to Yes and No in "SoldAsVacant" Field:
SELECT SoldAsVacant, COUNT(SoldAsVacant) FROM DataCleaning.nashvillehousing
GROUP BY SoldAsVacant ORDER BY COUNT(SoldAsVacant) desc;
SELECT DISTINCT(SoldAsVacant), 
CASE WHEN SoldAsVacant= 'Y' THEN 'Yes'
	 WHEN SoldAsVacant= 'N' THEN 'No'
     ELSE SoldAsVacant 
END
FROM DataCleaning.nashvillehousing;
UPDATE DataCleaning.nashvillehousing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant= 'Y' THEN 'Yes'
	 WHEN SoldAsVacant= 'N' THEN 'No'
     ELSE SoldAsVacant 
END;
-------------------------------------------------------------------------------------------------------------
-- 5. Remove Duplicates:
SELECT UniqueID, row_number() 
OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference, OwnerAddress) as rownum
FROM DataCleaning.nashvillehousing;
DELETE FROM DataCleaning.nashvillehousing
WHERE UniqueID IN 
(select a.UniqueID from
(SELECT UniqueID, row_number() 
OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference, OwnerAddress) as rownum
FROM DataCleaning.nashvillehousing) as a
WHERE a.rownum > 1);
-------------------------------------------------------------------------------------------------------------
-- 6. Delete unused columns:
ALTER TABLE DataCleaning.nashvillehousing
DROP OwnerAddress,
drop PropertyAddress;
