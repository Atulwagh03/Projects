Select * from Portfolio_Project..[dbo.NashvilleHousing]


--Standardize sale date

Select SaleDateConverted , CONVERT(Date,SaleDate)
from Portfolio_Project..[dbo.NashvilleHousing]

Update [dbo.NashvilleHousing]
SET SaleDate = CONVERT(Date, SaleDate)

ALTER Table [dbo.NashvilleHousing]
Add SaleDateConverted Date;

Update [dbo.NashvilleHousing]
SET SaleDateConverted = CONVERT(Date, SaleDate)


-- Populate Property Add

Select *
from Portfolio_Project..[dbo.NashvilleHousing]
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portfolio_Project..[dbo.NashvilleHousing] a
JOIN Portfolio_Project..[dbo.NashvilleHousing] b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portfolio_Project..[dbo.NashvilleHousing] a
JOIN Portfolio_Project..[dbo.NashvilleHousing] b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

-- Turning Address into sperate columns (Address, City,State)

Select PropertyAddress
from Portfolio_Project..[dbo.NashvilleHousing]
--where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as Address

from Portfolio_Project..[dbo.NashvilleHousing]

ALTER Table [dbo.NashvilleHousing] 
Add PropertySplitAddress Nvarchar(255);

Update [dbo.NashvilleHousing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

ALTER Table [dbo.NashvilleHousing]
Add PropertySplitCity Nvarchar(255);

Update [dbo.NashvilleHousing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))

Select *
from Portfolio_Project..[dbo.NashvilleHousing]


--OWNERADD

Select OwnerAddress
from Portfolio_Project..[dbo.NashvilleHousing]

Select
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

from Portfolio_Project..[dbo.NashvilleHousing]

ALTER Table [dbo.NashvilleHousing] 
Add OwnerSplitAddress Nvarchar(255);

Update [dbo.NashvilleHousing]
SET OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER Table [dbo.NashvilleHousing]
Add OwnerSplitCity Nvarchar(255);

Update [dbo.NashvilleHousing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER Table [dbo.NashvilleHousing]
Add OwnerSplitState Nvarchar(255);

Update [dbo.NashvilleHousing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)


Select *
from Portfolio_Project..[dbo.NashvilleHousing]

-- "Sold as Vacant" to YES & NO

Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
From Portfolio_Project..[dbo.NashvilleHousing]
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
CASE when SoldAsVacant = 'Y' THEN 'YES'
      when SoldAsVacant = 'N' THEN 'NO'
	  Else SoldAsVacant
	  End
From Portfolio_Project..[dbo.NashvilleHousing]

update [dbo.NashvilleHousing] 
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'YES'
      when SoldAsVacant = 'N' THEN 'NO'
	  Else SoldAsVacant
	  End


-- Remove Duplicates

WITH RowNumCte AS (
Select *,
       ROW_NUMBER() over ( 
	   PARTITION BY ParcelID,
	   PropertyAddress,SalePrice,SaleDate,LegalReference
	   ORDER BY 
	      UniqueID
		  ) row_num

From Portfolio_Project..[dbo.NashvilleHousing]
--order by ParcelID
)

Select *
From RowNumCte
Where row_num>1
order by PropertyAddress


-- Drop unused columns
Select *
From Portfolio_Project..[dbo.NashvilleHousing]

Alter table  Portfolio_Project..[dbo.NashvilleHousing]
Drop Column OwnerAddress, TaxDistrict, PropertyAddress,SaleDate




