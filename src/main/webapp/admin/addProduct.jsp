<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .form-wrap{
        margin: 25px auto;
        background:white;
        border-radius:14px;
        padding:22px;
        box-shadow:0 8px 20px rgba(0,0,0,0.06);
        max-width:900px;
        width: 100%;
        box-sizing: border-box;
    }


    .form-title{

        margin:0 0 18px 0;
        font-size:22px;
        font-weight:800;
        color:#0f172a;
    }

    .grid{

        display:grid;
        grid-template-columns:1fr 1fr;
        gap:14px;
    }

    .field{ display:flex; flex-direction:column; gap:8px; }
    .field label{
        font-weight:700;
        font-size:13px;
        color:#334155;
    }

    .field input, .field textarea{
        border:1px solid #e2e8f0;
        border-radius:12px;
        padding:12px 14px;
        font-size:14px;
        outline:none;
        transition:.15s;
        background:#fff;
    }

    .field input:focus, .field textarea:focus{
        border-color:#0ea5e9;
        box-shadow:0 0 0 4px rgba(14,165,233,.15);
    }

    .field textarea{
        min-height:110px;
        resize:vertical;
    }

    .span-2{ grid-column: span 2; }

    .hint{
        font-size:12px;
        color:#64748b;
        margin-top:-4px;
    }

    .actions{
        margin-top:16px;
        display:flex;
        gap:10px;
        justify-content:flex-end;
    }

    .btnx{
        border:none;
        border-radius:12px;
        padding:10px 16px;
        font-weight:800;
        cursor:pointer;
        text-decoration:none;
        display:inline-flex;
        align-items:center;
        gap:8px;
        color:white;
    }

    .btn-save{ background:#16a34a; }
    .btn-save:hover{ background:#15803d; }

    .btn-back{ background:#334155; }
    .btn-back:hover{ background:#1f2937; }



    body{
        margin: 0;
        background: radial-gradient(circle at top, #22c55e 0%, #16a34a 45%, #15803d 100%);
        display:flex;
        justify-content:center;
        align-items:center;
    }


    @media(max-width: 900px){
        .grid{ grid-template-columns:1fr; }
        .span-2{ grid-column: span 1; }
        .actions{ justify-content:stretch; }
        .btnx{ justify-content:center; width:100%; }
    }
</style>

<div class="form-wrap" >
    <div class="form-title">Add New Product</div>

    <form action="<%=request.getContextPath()%>/addProduct" method="post">
        <div class="grid">

            <div class="field">
                <label>Product Name</label>
                <input type="text" name="name" placeholder="e.g. Yamaha Acoustic Guitar F310" required>
            </div>

            <div class="field">
                <label>Category</label>
                <input type="text" name="category" placeholder="e.g. guitars / drums / keyboards" required>
            </div>

            <div class="field span-2">
                <label>Description</label>
                <textarea name="description" placeholder="Short product description..." required></textarea>
            </div>

            <div class="field">
                <label>Price (RM)</label>
                <input type="number" step="0.01" min="0" name="price" placeholder="e.g. 599.00" required>
            </div>

            <div class="field">
                <label>Stock Quantity</label>
                <input type="number" min="0" name="quantity" placeholder="e.g. 10" required>
            </div>

            <div class="field span-2">
                <label>Image URL (optional)</label>
                <input type="text" name="image" placeholder="e.g. images/yamaha.png OR https://...">
                <div class="hint">Leave empty if no image. You can update later.</div>
            </div>

        </div>

        <div class="actions">
            <a class="btnx btn-back" href="<%=request.getContextPath()%>/adminProducts"> Back</a>
            <button class="btnx btn-save" type="submit"> Add Product</button>
        </div>
    </form>
</div>
