
/* Cleaning Data */

SELECT * FROM [Project Covid Analysis]..nashvillehousing

-- Standardize Date Format

SELECT SaleDate, CONVERT(Date, SaleDate) 
FROM [Project Covid Analysis]..nashvillehousing

ALTER TABLE nashvillehousing
ADD SaleDateConverted Date

UPDATE nashvillehousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDateConverted 
FROM [Project Covid Analysis]..nashvillehousing

-- Populate Property Address Data

SELECT PropertyAddress
FROM [Project Covid Analysis]..nashvillehousing
WHERE PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Project Covid Analysis]..nashvillehousing a
JOIN [Project Covid Analysis]..nashvillehousing b
	ON a.ParcelID = b.ParcelID 
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Project Covid Analysis]..nashvillehousing a
JOIN [Project Covid Analysis]..nashvillehousing b
	ON a.ParcelID = b.ParcelID 
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- Breaking out Address into individual Columns (Address, City, State)

SELECT PropertyAddress
FROM [Project Covid Analysis]..nashvillehousing

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as FirstAddress,
	SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as LastAddress
FROM [Project Covid Analysis]..nashvillehousing

USE [Project Covid Analysis]

ALTER TABLE nashvillehousing
ADD PropertySplitAddress Nvarchar(255), 
	PropertySplitCity Nvarchar(255)

-- Multiple ADD can be used in ALTER
-- Each UPDATE can hold only one query
-- SUBSTRING move forward, PARSENAME move backward
-- PARSENAME only take '.' as delimiter

UPDATE nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

UPDATE nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT * 
FROM [Project Covid Analysis]..nashvillehousing

SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),1),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
FROM [Project Covid Analysis]..nashvillehousing

ALTER TABLE nashvillehousing
	ADD OwnerSplitAddress Nvarchar(255),
		OwnerSplitCity Nvarchar(255), 
		OwnerSplitState Nvarchar(255) 

UPDATE nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)
UPDATE nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddsress,',','.'),2)
UPDATE nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

-- Change Y and N to Yes and No in "Sold as Vacant"

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM [Project Covid Analysis]..nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
			WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE SoldAsVacant
		END
FROM [Project Covid Analysis]..nashvillehousing	

UPDATE nashvillehousing
Set SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
			WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE SoldAsVacant
		END
FROM [Project Covid Analysis]..nashvillehousing	

-- Remove Duplicates

WITH RowNumCTE As (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
	ORDER BY UniqueID) row_num
FROM [Project Covid Analysis]..nashvillehousing)

DELETE FROM RowNumCTE
WHERE row_num > 1

SELECT * FROM RowNumCTE
WHERE row_num > 1

-- Delete Unused Columns

USE [Project Covid Analysis]
ALTER TABLE nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE nashvillehousing
DROP COLUMN SaleDate

SELECT * 
FROM [Project Covid Analysis]..nashvillehousing
