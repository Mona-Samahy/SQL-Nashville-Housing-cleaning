--cleaning date in sql queries

select *
from ProtflioProject.dbo.NashvilleHousing

--------------------------------------------------------------------
--standardixe date format
select SaleDateConverted, CONVERT(Date,SaleDate)
from ProtflioProject.dbo.NashvilleHousing


Update NashvilleHousing
set SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly
ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
set SaleDateConverted = CONVERT(date,SaleDate)

-------------------------------------------------------------
-- Populate Property Address data


select * 
from ProtflioProject.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress
from ProtflioProject.dbo.NashvilleHousing a
JOIN ProtflioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
WHERE a.PropertyAddress IS NULL


Update a
SET PropertyAddress =ISNULL(a.PropertyAddress, b.PropertyAddress)
from ProtflioProject.dbo.NashvilleHousing a
JOIN ProtflioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
WHERE a.PropertyAddress IS NULL


------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)


select PropertyAddress 
from ProtflioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress )-1) AS Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))AS Address


from ProtflioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From ProtflioProjectt.dbo.NashvilleHousing

select OwnerAddress
from ProtflioProject.dbo.NashvilleHousing


select PARSENAME(replace(OwnerAddress, ',' , '.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From ProtflioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From PrortfolioProject.dbo.NashvilleHousing

------------------------------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" field

select distinct (SoldAsVacant), Count(SoldAsVacant)
from ProtflioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, CASE when SoldAsVacant='Y' THEN 'YES'
       WHEN SoldAsVacant= 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

from ProtflioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant =CASE when SoldAsVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant= 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
from ProtflioProject.dbo.NashvilleHousing

--------------------------------------------------------------
--Remove Duplicates



WITH RowNumCTE AS(
select *,
        ROW_NUMBER() OVER(
        PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				 UniqueID
				 )row_num
from ProtflioProject.dbo.NashvilleHousing
)
Select *
From RowNumCTE
where row_num > 1
order by PropertyAddress


Select *
From ProtflioProject.dbo.NashvilleHousing


------------------------------------------------------------
--Delete Unused Columns

Select *
from ProtflioProject.dbo.NashvilleHousing

ALTER TABLE ProtflioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress,SaleDate